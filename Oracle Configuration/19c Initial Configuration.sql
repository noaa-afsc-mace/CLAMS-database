
--- create tablespaces


CREATE TEMPORARY TABLESPACE TEMP01
  TEMPFILE
    'D:\Oracle\app\macebase\oradata\MACEBASE\temp02.dbf'
  SIZE 128M
  AUTOEXTEND ON;
  
CREATE TABLESPACE MACEBASE
  DATAFILE
    'D:\Oracle\app\macebase\oradata\MACEBASE\macebase01.dbf'
  SIZE 256M
  AUTOEXTEND ON
  EXTENT MANAGEMENT LOCAL AUTOALLOCATE;
  
--  As of 1/2021 macebase now exceeds 32GB so we need multiple
--  tablespace files. We'll create two more below for a total
--  of 3 files to contain up to 96GB of data.
ALTER TABLESPACE MACEBASE
  ADD DATAFILE
    'D:\Oracle\app\macebase\oradata\MACEBASE\macebase02.dbf'
  SIZE 256M
  AUTOEXTEND ON;

ALTER TABLESPACE MACEBASE
  ADD DATAFILE
    'D:\Oracle\app\macebase\oradata\MACEBASE\macebase03.dbf'
  SIZE 256M
  AUTOEXTEND ON;
 
CREATE TABLESPACE INDEXES
  DATAFILE
    'D:\Oracle\app\macebase\oradata\MACEBASE\indexes01.dbf'
  SIZE 64M
  AUTOEXTEND ON
  EXTENT MANAGEMENT LOCAL AUTOALLOCATE;
 

---  create the user profiles. MACE_AT_SEA was the old profile
---  passprofuser1 is the new profile name used at AFSC

CREATE PROFILE "MACE_AT_SEA" LIMIT
	CPU_PER_SESSION UNLIMITED
	CPU_PER_CALL UNLIMITED
	CONNECT_TIME UNLIMITED
	IDLE_TIME UNLIMITED
	SESSIONS_PER_USER UNLIMITED
	LOGICAL_READS_PER_SESSION UNLIMITED
	LOGICAL_READS_PER_CALL UNLIMITED
	PRIVATE_SGA UNLIMITED
	COMPOSITE_LIMIT UNLIMITED
	PASSWORD_LIFE_TIME UNLIMITED
	PASSWORD_GRACE_TIME DEFAULT
	PASSWORD_REUSE_MAX UNLIMITED
	PASSWORD_REUSE_TIME UNLIMITED
	PASSWORD_LOCK_TIME 1
	FAILED_LOGIN_ATTEMPTS 5;

CREATE PROFILE "PASSPROFUSER1" LIMIT
	CPU_PER_SESSION UNLIMITED
	CPU_PER_CALL UNLIMITED
	CONNECT_TIME UNLIMITED
	IDLE_TIME UNLIMITED
	SESSIONS_PER_USER UNLIMITED
	LOGICAL_READS_PER_SESSION UNLIMITED
	LOGICAL_READS_PER_CALL UNLIMITED
	PRIVATE_SGA UNLIMITED
	COMPOSITE_LIMIT UNLIMITED
	PASSWORD_LIFE_TIME UNLIMITED
	PASSWORD_GRACE_TIME DEFAULT
	PASSWORD_REUSE_MAX UNLIMITED
	PASSWORD_REUSE_TIME UNLIMITED
	PASSWORD_LOCK_TIME 1
	FAILED_LOGIN_ATTEMPTS 5;	
	
	
CREATE role USERS;
GRANT create cluster to users;
GRANT create view to users;
GRANT create procedure to users;
GRANT create sequence to users;
GRANT create synonym to users;
GRANT create trigger to users;
GRANT create session to users;
GRANT create materialized view to users;
GRANT create table to users;
GRANT alter session to users;

CREATE role DEVELOPER;
GRANT manage scheduler to DEVELOPER;
GRANT create job to DEVELOPER;
GRANT resumable to DEVELOPER;
GRANT drop profile to DEVELOPER;
GRANT create sequence to DEVELOPER;
GRANT create operator to DEVELOPER;
GRANT alter profile to DEVELOPER;
GRANT create materialized view to DEVELOPER;
GRANT create procedure to DEVELOPER;
GRANT create synonym to DEVELOPER;
GRANT global query rewrite to DEVELOPER;
GRANT create profile to DEVELOPER;
GRANT create public synonym to DEVELOPER;
GRANT drop public synonym to DEVELOPER;
GRANT create type to DEVELOPER;
GRANT create library to DEVELOPER;
GRANT create cluster to DEVELOPER;
GRANT create external job to DEVELOPER;
GRANT on commit refresh to DEVELOPER;
GRANT create dimension to DEVELOPER;
GRANT query rewrite to DEVELOPER;
GRANT create indextype to DEVELOPER;
GRANT create trigger to DEVELOPER;

--  create some other roles we don't explicitly use but need
--  for clean imports.
CREATE role maceloader_role;
CREATE role maceuser_role;
CREATE role mb2_user;
CREATE role race_data_select;

--  create the App profile
CREATE profile app
  limit password_reuse_max unlimited;


create user macebase identified by "xxxxxxxx";
GRANT unlimited tablespace to macebase;
grant users to macebase;
grant developer to macebase;

create user clamsbase identified by "xxxxxxxx";
GRANT unlimited tablespace to clamsbase;
grant users to clamsbase;
grant developer to clamsbase;

create user clamsbase2 identified by "xxxxxxxx";
GRANT unlimited tablespace to clamsbase2;
grant users to clamsbase2;
grant developer to clamsbase2;

create user macebase2 identified by "xxxxxxxx";
GRANT unlimited tablespace to macebase2;
grant users to macebase2;
grant developer to macebase2;
--  grant execute on dbms_lock for macebase2 bounds checks triggers
GRANT execute on dbms_lock to macebase2;


create user "mace-user" identified by "xxxxxxxx";
GRANT connect to "mace-user";
grant users to "mace-user";


--  create "oracle" user which we use to manage database
CREATE user oracle identified by "xxxxxxxx";
GRANT connect to oracle;
GRANT dba to oracle;
GRANT sysdba to oracle;

