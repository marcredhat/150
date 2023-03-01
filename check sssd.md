

https://blog.cloudera.com/best-practices-guide-for-systems-security-services-daemon-configuration-and-installation-part-1/


```
[rocky@full5 ~]$ id marc
uid=1763800003(marc) gid=1763800003(marc) groups=1763800003(marc),1763800005(hadoop_admins),1763800000(admins)

[rocky@full5 ~]$ kinit marc
Password for marc@BASE.LOCAL:
[rocky@full5 ~]$  hdfs dfs -ls /
Found 7 items
drwxr-xr-x   - hbase hbase           0 2023-02-28 04:57 /hbase
drwxr-xr-x   - hdfs  admins          0 2023-02-28 04:55 /ranger
drwxrwxr-x   - solr  solr            0 2023-02-28 04:56 /solr-infra
drwxrwxrwt   - hdfs  admins          0 2023-02-28 05:06 /tmp
drwxr-xr-x   - hdfs  admins          0 2023-02-28 05:04 /user
drwxr-xr-x   - hdfs  admins          0 2023-02-28 05:01 /warehouse
drwxr-xr-x   - hdfs  admins          0 2023-02-28 04:58 /yarn
```
