with c as (
  select
        500 nrep,
        50 maxgsiz
  from dual
),
reps as (
  select level rep
  from dual
  cross join c
  connect by level <= c.nrep
),
pers as (
  select round(sqrt(2*level)) npers
  from dual
  cross join c
  connect by level <= c.maxgsiz*(c.maxgsiz+1)/2
),
bds as (
  select
        reps.rep,
        pers.npers,
        floor(dbms_random.value(1,366)) bd
  from reps
  cross join pers
),
mtch as (
  select
        bds.npers,
        case count(distinct bds.bd ) when bds.npers then 0 else 1 end match
  from bds
  group by bds.rep, bds.npers, null
  order by bds.npers
),
nm as (
  select mtch.npers, sum (mtch.match) nmatch
  from mtch
  group by mtch.npers
),
sol as (
  select first_value ( nm.npers ) over ( order by abs ( nm.nmatch - c.nrep / 2 ) ) npers
  from nm
  cross join c
)
select npers
  from sol where rownum = 1
;

