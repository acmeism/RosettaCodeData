/*
This code is an implementation of Babbage Problem in SQL ORACLE 19c
p_ziel  -- the substring to search for, which can start with leading zeros
p_max   -- upper bound of the cycle
v_max   -- safe determination of the upper bound of the cycle
v_start -- safe starting point
*/
with
  function babbage(p_ziel in varchar2, p_max integer) return varchar2 is
    v_max    integer := greatest(p_max,to_number('1E+'||length(to_char(p_ziel))));
    v_start  number := case when substr(p_ziel,1,1)='0' then ceil(sqrt('1'||p_ziel)) else ceil(sqrt(p_ziel)) end;
    v_length number := to_number('1E+'||length(to_char(p_ziel)));
  begin
    -- first check
    if substr(p_ziel,-1) in (2,3,7,8) then
      return 'The exact square of an integer cannot end with '''||substr(p_ziel,-1)||''', so there is no such smallest number whose square ends in '''||p_ziel||'''';
    end if;
    -- second check
    if regexp_count(p_ziel,'([^0]0{1,}$)')=1 and mod(regexp_count(regexp_substr(p_ziel,'(0{1,}$)'),'0'),2)=1 then
      return 'An exact square of an integer cannot end with an odd number of zeros, so there is no such smallest number whose square ends in '''||p_ziel||'''';
    end if;
    -- main cycle
    while v_start < v_max loop
      exit when mod(v_start**2,v_length) = p_ziel;
      v_start := v_start + 1;
    end loop;
    -- output
    if v_start = v_max then
      return 'There is no such smallest number before '||v_max||' whose square ends in '''||p_ziel||'''';
    else
      return ''||v_start||' is the smallest number, whose square '||regexp_replace(to_char(v_start**2),'(\d{1,})('||p_ziel||')','\1''\2''')||' ends in '''||p_ziel||'''';
    end if;
    --
  end;

--Test
select babbage('222',100000) as res from dual
union all
select babbage('33',100000) as res from dual
union all
select babbage('17',100000) as res from dual
union all
select babbage('888',100000) as res from dual
union all
select babbage('1000',100000) as res from dual
union all
select babbage('000',100000) as res from dual
union all
select babbage('269696',100000) as res from dual -- strict Babbage Problem
union all
select babbage('269696',10) as res from dual
union all
select babbage('169696',10) as res from dual
union all
select babbage('19696',100000) as res from dual
union all
select babbage('04',100000) as res from dual;
