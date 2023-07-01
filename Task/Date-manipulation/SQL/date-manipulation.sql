-- March 7 2009 7:30pm EST

select
TO_TIMESTAMP_TZ(
'March 7 2009 7:30pm EST',
'MONTH DD YYYY HH:MIAM TZR'
)
at time zone 'US/Eastern' orig_dt_time
from dual;

-- 12 hours later DST change

select
(TO_TIMESTAMP_TZ(
'March 7 2009 7:30pm EST',
'MONTH DD YYYY HH:MIAM TZR'
)+
INTERVAL '12' HOUR)
at time zone 'US/Eastern' plus_12_dst
from dual;

-- 12 hours later no DST change
-- Arizona time, always MST

select
(TO_TIMESTAMP_TZ(
'March 7 2009 7:30pm EST',
'MONTH DD YYYY HH:MIAM TZR'
)+
INTERVAL '12' HOUR)
at time zone 'US/Arizona' plus_12_nodst
from dual;
