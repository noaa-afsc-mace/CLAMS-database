--- tablespace files can be 32GB max in size. Macebase data now exceeds this
--  size so we had to add additional tablespace files to hold all of this
--  data.

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