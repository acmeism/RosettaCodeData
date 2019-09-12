-- setting up the test data

create table people (age number(3), name varchar2(30));
insert into people (age, name)
  select 27, 'Jonah'  from dual union all
  select 18, 'Alan'   from dual union all
  select 28, 'Glory'  from dual union all
  select 18, 'Popeye' from dual union all
  select 28, 'Alan'   from dual
;

create table nemesises (name varchar2(30), nemesis varchar2(30));
insert into nemesises (name, nemesis)
  select 'Jonah', 'Whales'  from dual union all
  select 'Jonah', 'Spiders' from dual union all
  select 'Alan' , 'Ghosts'  from dual union all
  select 'Alan' , 'Zombies' from dual union all
  select 'Glory', 'Buffy'   from dual
;
