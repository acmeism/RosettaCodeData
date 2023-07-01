/*
This code is an implementation of "Set consolidation" in SQL ORACLE 19c
p_list_of_sets -- input string
delimeter by default "|"
*/
with
function set_consolidation(p_list_of_sets in varchar2)
return varchar2 is
   --
   v_list_of_sets varchar2(32767) := p_list_of_sets;
   v_output       varchar2(32767) ;
   v_set_1        varchar2(2000) ;
   v_set_2        varchar2(2000) ;
   v_pos_set_1    pls_integer;
   v_pos_set_2    pls_integer;
   --
   function remove_duplicates(p_set varchar2)
   return varchar2 is
      v_set varchar2(1000) := p_set;
   begin
      for i in 1..length(v_set)
      loop
         v_set := regexp_replace(v_set, substr(v_set, i, 1), '', i+1, 0) ;
      end loop;
      return v_set;
   end;
   --
begin
   --cleaning
   v_list_of_sets := ltrim(v_list_of_sets, '{') ;
   v_list_of_sets := rtrim(v_list_of_sets, '}') ;
   v_list_of_sets := replace(v_list_of_sets, ' ', '') ;
   v_list_of_sets := replace(v_list_of_sets, ',', '') ;
   --set delimeter "|"
   v_list_of_sets := replace(v_list_of_sets, '}{', '|') ;
   --
   <<loop_through_sets>>
   while regexp_count(v_list_of_sets, '[^|]+') > 0
   loop
      v_set_1 := regexp_substr(v_list_of_sets, '[^|]+', 1, 1) ;
      v_pos_set_1 := regexp_instr(v_list_of_sets, '[^|]+', 1, 1) ;
      --
      <<loop_for>>
      for i in 1..regexp_count(v_list_of_sets, '[^|]+')-1
      loop
         --
         v_set_2 := regexp_substr(v_list_of_sets, '[^|]+', 1, i+1) ;
         v_pos_set_2 := regexp_instr(v_list_of_sets, '[^|]+', 1, i+1) ;
         --
         if regexp_count(v_set_2, '['||v_set_1||']') > 0 then
            v_list_of_sets := regexp_replace(v_list_of_sets, v_set_1, remove_duplicates(v_set_1||v_set_2), v_pos_set_1, 1) ;
            v_list_of_sets := regexp_replace(v_list_of_sets, v_set_2, '', v_pos_set_2, 1) ;
            continue loop_through_sets;
         end if;
         --
      end loop loop_for;
      --
      v_output := v_output||'{'||rtrim(regexp_replace(v_set_1, '([A-Z])', '\1,'), ',') ||'}';
      v_list_of_sets := regexp_replace(v_list_of_sets, v_set_1, '', 1, 1) ;
      --
   end loop loop_through_sets;
   --
   return replace(nvl(v_output,'{}'),'}{','},{') ;
end;

--Test
select lpad('{}',50) || ' ==> ' || set_consolidation('{}') as output from dual
union all
select lpad('{},{}',50) || ' ==> ' || set_consolidation('{},{}') as output from dual
union all
select lpad('{},{B}',50) || ' ==> ' || set_consolidation('{},{B}') as output from dual
union all
select lpad('{D}',50) || ' ==> ' || set_consolidation('{D}') as output from dual
union all
select lpad('{F},{A},{A}',50) || ' ==> ' || set_consolidation('{F},{A},{A}') as output from dual
union all
select lpad('{A,B},{B}',50) || ' ==> ' || set_consolidation('{A,B},{B}') as output from dual
union all
select lpad('{A,D},{D,A}',50) || ' ==> ' || set_consolidation('{A,D},{D,A}') as output from dual
union all
--Test RosettaCode
select '-- Test RosettaCode' as output from dual
union all
select lpad('{A,B},{C,D}',50) || ' ==> ' || set_consolidation('{A,B},{C,D}') as output from dual
union all
select lpad('{A,B},{B,D}',50) || ' ==> ' || set_consolidation('{A,B},{B,D}') as output from dual
union all
select lpad('{A,B},{C,D},{D,B}',50) || ' ==> ' || set_consolidation('{A,B},{C,D},{D,B}') as output from dual
union all
select lpad('{H,   I,  K}, {A,B},   {C,D},   {D,B},    {F,G,H}',50) || ' ==> ' || set_consolidation('{H,   I,  K}, {A,B},   {C,D},   {D,B},    {F,G,H}') as output from dual
union all
select lpad('HIK|AB|CD|DB|FGH',50) || ' ==> ' || set_consolidation('HIK|AB|CD|DB|FGH') as output from dual
;
/
