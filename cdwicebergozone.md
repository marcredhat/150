#https://medium.com/engineering-cloudera/open-data-lakehouse-powered-by-apache-iceberg-on-apache-ozone-a225d5dcfe98

#Iceberg on HDFS
CREATE TABLE default.iceberg_weblogs_noozone (
`time` timestamp,
app string,
request string,
response_code int)
PARTITIONED BY SPEC(day(`time`))
STORED BY ICEBERG
##LOCATION 'ofs://OPEN-STG-01/tenant1/warehouse/iceberg/default/iceberg_weblogs_ozone';

INSERT INTO default.iceberg_weblogs_noozone VALUES('2023-01-17 18:35:49', 'metastore', 'GET /metastore/table/default/sample_07 HTTP/1.1', 200);
INSERT INTO default.iceberg_weblogs_noozone VALUES('2023-01-17 18:50:12', 'search', 'GET /search/?collection=10000001 HTTP/1.1', 200);
INSERT INTO default.iceberg_weblogs_noozone VALUES('2023-01-17 19:10:30', 'metastore', 'GET /metastore/table/default/sample_07 HTTP/1.1', 200);


##Iceberg on Ozone
CREATE TABLE default.iceberg_weblogs_ozone (
`time` timestamp,
app string,
request string,
response_code int)
PARTITIONED BY SPEC(day(`time`))
STORED BY ICEBERG
LOCATION 'ofs://OPEN-STG-01/tenant1/warehouse/iceberg/default/iceberg_weblogs_ozone';

INSERT INTO default.iceberg_weblogs_ozone VALUES('2023-01-17 18:35:49', 'metastore', 'GET /metastore/table/default/sample_07 HTTP/1.1', 200);
INSERT INTO default.iceberg_weblogs_ozone VALUES('2023-01-17 18:50:12', 'search', 'GET /search/?collection=10000001 HTTP/1.1', 200);
INSERT INTO default.iceberg_weblogs_ozone VALUES('2023-01-17 19:10:30', 'metastore', 'GET /metastore/table/default/sample_07 HTTP/1.1', 200);


SELECT * FROM default.iceberg_weblogs_noozone.history
SELECT * FROM default.iceberg_weblogs_noozone.snapshots 


SELECT * FROM default.iceberg_weblogs_ozone.history
SELECT * FROM default.iceberg_weblogs_ozone.snapshots 
SELECT * FROM default.iceberg_weblogs_ozone for system_version as of 3504781029202510376

#[rocky@full7 ~]$ ozone fs -ls -R ofs://OPEN-STG-01/tenant1/warehouse/iceberg/default/iceberg_weblogs_ozone


#Time Travel
#Bob & team have developed a downstream application, app_alert, 
#to scan the web logs in batches of 15 minute time intervals and send alerts to app owners 
#whenever it sees error codes for fast resolution of potential issues. 
#On date 2023-01-19, app owners of search app were notified of an issue by users. 
#The app owners checked the web logs table and found error logs around 7:11 PM 
#which helped them resolve the issue.
#However, they were perplexed because even though they could see the error log in the table, 
#the app_alert job had not alerted them about this log.
#Since Iceberg supports time travel, they decided to compare the results of the SQL that 
#the app_alert job ran at the time of processing the corresponding batch with the latest results. 
#And lo and behold, they found that the error log was missed by the app_alert job because it arrived late for an unexpected reason.

SELECT * FROM iceberg_weblogs FOR SYSTEM_TIME AS OF '2023-03-05 19:15:00'
WHERE `time` between '2023-01-15 19:00:00' and '2023-01-19 19:15:00' and app='search';


# Partition evolution
 
#Bob & team have been running the housekeeping job for awhile now and they notice that along with the time interval users also usually query for web logs from a specific application, so they decide to add column app as an additional partition for the weblogs data.
#With Hive partitioning, in-place partition evolution is not possible.
#With Iceberg, this becomes as simple as modifying the existing partition spec with a single alter table command and no table rewrites.

CREATE TABLE default.iceberg_evolution (
`time` timestamp,
app string,
request string,
response_code int)
PARTITIONED BY SPEC(day(`time`))
STORED BY ICEBERG
##LOCATION 'ofs://OPEN-STG-01/tenant1/warehouse/iceberg/default/iceberg_weblogs_ozone';

ALTER TABLE default.iceberg_evolution
SET PARTITION SPEC(day(`time`), app);

INSERT INTO default.iceberg_evolution VALUES('2023-01-18 18:35:49', 'metastoremarc', 'GET /metastore/table/default/sample_07 HTTP/1.1', 200);
INSERT INTO default.iceberg_evolution VALUES('2023-01-18 18:50:12', 'search', 'GET /search/?collection=10000001 HTTP/1.1', 200);
INSERT INTO default.iceberg_evolution VALUES('2023-01-18 19:10:30', 'metastore', 'GET /metastore/table/default/sample_07 HTTP/1.1', 200);

[rocky@full7 ~]$ hdfs dfs -ls -R / | grep evol
drwxrwx---+  - hive   hive            0 2023-03-08 02:52 /warehouse/tablespace/external/hive/_tmp.iceberg_evolution
drwxrwx---+  - hive   hive            0 2023-03-08 02:52 /warehouse/tablespace/external/hive/iceberg_evolution
drwxrwx---+  - hive   hive            0 2023-03-08 02:52 /warehouse/tablespace/external/hive/iceberg_evolution/.hive-staging_hive_2023-03-08_02-52-12_789_4815704756727918876-36
drwxrwx---+  - hive   hive            0 2023-03-08 02:52 /warehouse/tablespace/external/hive/iceberg_evolution/data
drwxrwx---+  - hive   hive            0 2023-03-08 02:52 /warehouse/tablespace/external/hive/iceberg_evolution/data/time_day=2023-01-18
drwxrwx---+  - hive   hive            0 2023-03-08 02:52 /warehouse/tablespace/external/hive/iceberg_evolution/data/time_day=2023-01-18/app=metastore
-rw-rw----+  3 hive   hive         1490 2023-03-08 02:52 /warehouse/tablespace/external/hive/iceberg_evolution/data/time_day=2023-01-18/app=metastore/00001-0-data-hive_20230308025212_4c4c1ab3-974a-444e-b22f-14d10ae58385-job_16782239678481_0000-11-00001.parquet
drwxrwx---+  - hive   hive            0 2023-03-08 02:52 /warehouse/tablespace/external/hive/iceberg_evolution/metadata
-rw-rw----+  3 hive   hive         2301 2023-03-08 02:49 /warehouse/tablespace/external/hive/iceberg_evolution/metadata/00000-e92bddf9-4430-4c5f-9242-2bbec1b05d5c.metadata.json
-rw-rw----+  3 hive   hive         2869 2023-03-08 02:49 /warehouse/tablespace/external/hive/iceberg_evolution/metadata/00001-4052e982-8d9a-4ce6-9d8f-3a62dff85961.metadata.json
-rw-rw----+  3 hive   hive         3936 2023-03-08 02:52 /warehouse/tablespace/external/hive/iceberg_evolution/metadata/00002-4784e431-7ea7-45e9-b313-6022038f04d5.metadata.json
-rw-rw----+  3 hive   hive         6480 2023-03-08 02:52 /warehouse/tablespace/external/hive/iceberg_evolution/metadata/789801fa-f109-4939-a921-2087a6c3f56c-m0.avro
-rw-rw----+  3 hive   hive         3814 2023-03-08 02:52 /warehouse/tablespace/external/hive/iceberg_evolution/metadata/snap-1600434829731789731-1-789801fa-f109-4939-a921-2087a6c3f56c.avro
drwxrwx---+  - hive   hive            0 2023-03-08 02:52 /warehouse/tablespace/external/hive/iceberg_evolution/temp





