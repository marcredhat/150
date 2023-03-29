
```
sudo -su oracle
cd
export ORACLE_HOME=/opt/oracle/product/19c/dbhome_1
export PATH=${PATH}:${ORACLE_HOME}/bin
sqlplus sys/cloudera@ORCLPDB1 as sysdba
```


https://stackoverflow.com/questions/63928724/what-do-the-various-tables-in-hive-metastore-contain

https://analyticsanvil.wordpress.com/2016/08/21/useful-queries-for-the-hive-metastore/

https://github.com/marcredhat/150/blob/main/cdwicebergozone.md

```
Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.3.0.0.0

SQL> SELECT p.PDB_ID, p.PDB_NAME, t.OWNER, t.TABLE_NAME FROM DBA_PDBS p, CDB_TABLES t WHERE p.PDB_ID > 2 AND p.PDB_ID = t.CON_ID and table_name like '%METASTORE%';

    PDB_ID
----------
PDB_NAME
--------------------------------------------------------------------------------
OWNER
--------------------------------------------------------------------------------
TABLE_NAME
--------------------------------------------------------------------------------
	 3
ORCLPDB1
HIVE1
METASTORE_DB_PROPERTIES
```


```
SELECT p.PDB_ID, p.PDB_NAME, t.OWNER, t.TABLE_NAME FROM DBA_PDBS p, CDB_TABLES t WHERE p.PDB_ID > 2 AND p.PDB_ID = t.CON_ID and table_name like '%TBL%'
```

```
SELECT t.* FROM hive1.TBLS t JOIN hive1.DBS d ON t.DB_ID = d.DB_ID WHERE d.NAME = 'default' and t.TBL_NAME  LIKE '%iceberg%';
```
