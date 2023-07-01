/*
This code is an implementation of gapful numbers in SQL ORACLE 19c
p_start -- start point
p_count -- total number to be found
*/
with
  function gapful_numbers(p_start in integer, p_count in integer) return varchar2 is
    v_start   integer := p_start;
    v_count   integer := 0;
    v_res     varchar2(32767);
  begin
    v_res := 'First '||p_count||' gapful numbers starting from '||p_start||': ';
    -- main cycle
    while true loop
      if mod(v_start,to_number(substr(v_start,1,1)||substr(v_start,-1))) = 0 then
         v_res := v_res || v_start;
         v_count := v_count + 1;
         exit when v_count = p_count;
         v_res := v_res || ', ';
      end if;
      v_start := v_start + 1;
    end loop;
    --
    return v_res;
    --
  end;

--Test
select gapful_numbers(100,30) as res from dual
union all
select gapful_numbers(1000000,15) as res from dual
union all
select gapful_numbers(1000000000,10) as res from dual;
/
