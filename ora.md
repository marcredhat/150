
```
sudo -su oracle
cd
export ORACLE_HOME=/opt/oracle/product/19c/dbhome_1
export PATH=${PATH}:${ORACLE_HOME}/bin
sqlplus sys/cloudera@ORCLPDB1 as sysdba
```

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
