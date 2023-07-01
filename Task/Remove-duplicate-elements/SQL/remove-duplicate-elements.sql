/*
This code is an implementation of "Remove duplicate elements" in SQL ORACLE 19c
p_in_str    -- input string
p_delimiter -- delimeter
*/
with
  function remove_duplicate_elements(p_in_str in varchar2, p_delimiter in varchar2 default ',') return varchar2 is
  v_in_str varchar2(32767) := replace(p_in_str,p_delimiter,',');
  v_res    varchar2(32767);
begin
  --
  execute immediate 'select listagg(distinct cv,:p_delimiter) from (select (column_value).getstringval() cv from xmltable(:v_in_str))'
     into v_res using p_delimiter, v_in_str;
  --
  return v_res;
  --
end;

--Test
select remove_duplicate_elements('1, 2, 3, "a", "b", "c", 2, 3, 4, "b", "c", "d"') as res from dual
union all
select remove_duplicate_elements('3 9 1 10 3 7 6 5 2 7 4 7 4 2 2 2 2 8 2 10 4 9 2 4 9 3 4 3 4 7',' ') as res from dual
;
