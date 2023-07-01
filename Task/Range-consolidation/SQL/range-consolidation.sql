/*
This code is an implementation of "Range consolidation" in SQL ORACLE 19c
p_list_of_sets -- input string
delimeter by default "|"
*/
with
function range_consolidation(p_list_of_sets in varchar2)
return varchar2 is
   --
   v_list_of_sets varchar2(32767) := p_list_of_sets;
   v_output       varchar2(32767);
   v_set_1        varchar2(2000);
   v_set_2        varchar2(2000);
   v_pos_set_1    pls_integer;
   v_pos_set_2    pls_integer;
   v_set_1_min    number;
   v_set_1_max    number;
   v_set_2_min    number;
   v_set_2_max    number;
   --
   function sort_set(p_in_str varchar2)
   return varchar2 is
      v_out varchar2(32767) := p_in_str;
   begin
     --
     with out_tab as
        (select to_number(regexp_substr(str, '[^,]+', 1, rownum, 'c', 0)) elem
           from
              (select p_in_str as str
                 from dual
              )
              connect by level <= regexp_count(str, '[^,]+')
        )
     select min(elem)||','||max(elem) end
       into v_out
       from out_tab;
     --
     return v_out;
   end;
   --
   function sort_output(p_in_str varchar2)
   return varchar2 is
      v_out varchar2(32767) := p_in_str;
   begin
     --
     with out_tab as
        (select to_number(regexp_substr(regexp_substr(str, '[^|]+', 1, rownum, 'c', 0), '[^,]+', 1, 1)) low_range
              , regexp_substr(str, '[^|]+', 1, rownum, 'c', 0) range_def
           from
              (select p_in_str as str
                 from dual
              )
              connect by level <= regexp_count(str, '[^|]+')
        )
     select listagg(range_def, '|') within group(order by low_range)
       into v_out
       from out_tab;
     --
     return v_out;
   end;
   --
begin
   --
   execute immediate ('alter session set NLS_NUMERIC_CHARACTERS = ''.,''');
   --
   --cleaning
   v_list_of_sets := ltrim(v_list_of_sets, '[');
   v_list_of_sets := rtrim(v_list_of_sets, ']');
   v_list_of_sets := replace(v_list_of_sets, ' ', '');
   --set delimeter "|"
   v_list_of_sets := regexp_replace(v_list_of_sets, '\]\,\[', '|', 1, 0);
   --
   <<loop_through_sets>>
   while regexp_count(v_list_of_sets, '[^|]+') > 0
   loop
      v_set_1 := regexp_substr(v_list_of_sets, '[^|]+', 1, 1);
      v_list_of_sets := regexp_replace(v_list_of_sets, v_set_1, sort_set(v_set_1), 1, 1);
      v_set_1 := sort_set(v_set_1);
      v_pos_set_1 := regexp_instr(v_list_of_sets, '[^|]+', 1, 1);
      --
      v_set_1_min := least(to_number(regexp_substr(v_set_1, '[^,]+', 1, 1)),to_number(regexp_substr(v_set_1, '[^,]+', 1, 2)));
      v_set_1_max := greatest(to_number(regexp_substr(v_set_1, '[^,]+', 1, 1)),to_number(regexp_substr(v_set_1, '[^,]+', 1, 2)));
      --
      <<loop_for>>
      for i in 1..regexp_count(v_list_of_sets, '[^|]+')-1
      loop
         --
         v_set_2 := regexp_substr(v_list_of_sets, '[^|]+', 1, i+1);
         v_list_of_sets := regexp_replace(v_list_of_sets, v_set_2, sort_set(v_set_2), 1, 1);
         v_set_2 := sort_set(v_set_2);
         v_pos_set_2 := regexp_instr(v_list_of_sets, '[^|]+', 1, i+1);
         v_set_2_min := least(to_number(regexp_substr(v_set_2, '[^,]+', 1, 1)),to_number(regexp_substr(v_set_2, '[^,]+', 1, 2)));
         v_set_2_max := greatest(to_number(regexp_substr(v_set_2, '[^,]+', 1, 1)),to_number(regexp_substr(v_set_2, '[^,]+', 1, 2)));
         --
        if greatest(v_set_1_min,v_set_2_min)-least(v_set_1_max,v_set_2_max) <= 0 then  --overlapping
           v_list_of_sets := regexp_replace(v_list_of_sets, v_set_1, ''||least(v_set_1_min,v_set_2_min)||','||greatest(v_set_1_max,v_set_2_max),v_pos_set_1,1);
           v_list_of_sets := regexp_replace(v_list_of_sets, v_set_2, '', v_pos_set_2, 1);
           continue loop_through_sets;
         end if;
         --
      end loop loop_for;
      --
      v_output := ltrim(v_output||'|'||least(v_set_1_min,v_set_1_max)||', '||greatest(v_set_1_min,v_set_1_max),'|');
      --
      v_output := sort_output(v_output);
      v_list_of_sets := regexp_replace(v_list_of_sets,v_set_1,'',1,1);
      --
   end loop loop_through_sets;
   --
   return '['||replace(v_output,'|','], [')||']';
end;

--Test
select lpad('[]',50) || ' ==> ' || range_consolidation('[]') as output from dual
union all
select lpad('[],[]',50) || ' ==> ' || range_consolidation('[],[]') as output from dual
union all
select lpad('[],[1,1]',50) || ' ==> ' || range_consolidation('[],[1,1]') as output from dual
union all
select lpad('[1.3]',50) || ' ==> ' || range_consolidation('[1.3]') as output from dual
union all
select lpad('[2,2],[1]',50) || ' ==> ' || range_consolidation('[2,2],[1]') as output from dual
union all
select lpad('[4,-1,0,1,5,7,7,7],[9,6,9,6,9]',50) || ' ==> ' || range_consolidation('[4,-1,0,1,5,7,7,7],[9,6,9,6,9]') as output from dual
union all
--Test RosettaCode
select '-- Test RosettaCode' as output from dual
union all
select lpad('[1.1, 2.2]',50) || ' ==> ' || range_consolidation('[1.1, 2.2]') as output from dual
union all
select lpad('[6.1, 7.2], [7.2, 8.3]',50) || ' ==> ' || range_consolidation('[6.1, 7.2], [7.2, 8.3]') as output from dual
union all
select lpad('[4, 3], [2, 1]',50) || ' ==> ' || range_consolidation('[4, 3], [2, 1]') as output from dual
union all
select lpad('[4, 3], [2, 1], [-1, -2], [3.9, 10]',50) || ' ==> ' || range_consolidation('[4, 3], [2, 1], [-1, -2], [3.9, 10]') as output from dual
union all
select lpad('[1, 3], [-6, -1], [-4, -5], [8, 2], [-6, -6]',50) || ' ==> ' || range_consolidation('[1, 3], [-6, -1], [-4, -5], [8, 2], [-6, -6]') as output from dual
union all
select lpad('1,3|-6,-1|-4,-5|8,2|-6,-6',50) || ' ==> ' || range_consolidation('1,3|-6,-1|-4,-5|8,2|-6,-6') as output from dual
/
;
/
