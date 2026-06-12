--() { :; }; exec db2 -txf "$0"

get instance;
connect to sample;
select 'Hello' from sysibm.sysdummy1;
values current date;
