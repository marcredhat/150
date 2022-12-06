CREATE TABLE Employee(
    id INT,
    firstname STRING,
    lastname STRING,
    gender STRING,
    designation STRING,
    city STRING,
    country STRING
) PARTITIONED BY (
    year INT
) ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES("skip.header.line.count"="1");


LOAD DATA INPATH 'hdfs://mchisinevski-1.mchisinevski.root.hwx.site:8020/user/marc/2012.txt' INTO TABLE Employee PARTITION(year=2012);
LOAD DATA INPATH 'hdfs://mchisinevski-1.mchisinevski.root.hwx.site:8020/user/marc/2013.txt' INTO TABLE Employee PARTITION(year=2013);
