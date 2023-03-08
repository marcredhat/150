https://medium.com/engineering-cloudera/open-data-lakehouse-powered-by-apache-iceberg-on-apache-ozone-a225d5dcfe98

```


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
```
