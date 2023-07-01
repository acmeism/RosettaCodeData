/*
This code is an implementation of "Sum digits of an integer" in SQL ORACLE 19c
p_in_str -- input string
*/
with
  function sum_digits(p_in_str in varchar2) return varchar2 is
  v_in_str varchar(32767) := translate(p_in_str,'*-+','*');
  v_sum integer;
begin
  --
  if regexp_count(v_in_str,'[0-9A-F]',1,'i')=length(v_in_str) then -- base 16
    execute immediate 'select sum('||regexp_replace(v_in_str,'(\w)','to_number(''\1'',''X'')+')||'0) from dual' into v_sum;
    --
  elsif regexp_count(v_in_str,'[0-9]',1,'i')=length(v_in_str) then -- base 10
    execute immediate 'select sum('||regexp_replace(v_in_str,'(\d)','\1+')||'0) from dual' into v_sum;
    --
  else
    return 'Sum of digits for integer "'||p_in_str||'" not defined';
    --
  end if;
  --
  return 'Sum of digits for integer "'||p_in_str||'" = '||v_sum;
end;

--Test
select sum_digits('') as res from dual
union all
select sum_digits('000') as res from dual
union all
select sum_digits('-010') as res from dual
union all
select sum_digits('+010') as res from dual
union all
select sum_digits('120034') as res from dual
union all
select sum_digits('FE') as res from dual
union all
select sum_digits('f0e') as res from dual
union all
select sum_digits('öst12') as res from dual;
