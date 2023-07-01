/*
This code is an implementation of "Range extraction" in SQL ORACLE 19c
p_list_of_sets -- input string
delimeter by default ","
p_format -- output format:
            0 => [-2,-1] [0,2]
            1 => -2--1,0-2
*/
with
function range_extraction(p_list_of_sets in varchar2, p_format integer default 0)
return varchar2 is
   --
   v_list_of_sets varchar2(32767) := p_list_of_sets;
   v_output       varchar2(32767) ;
   v_set_1        varchar2(2000) ;
   v_set_2        varchar2(2000) ;
   v_set_2_gr     pls_integer;
   v_max          pls_integer;
   --
   function sort_set(p_in_str varchar2)
   return varchar2 is
      v_out varchar2(32767) := p_in_str;
   begin
     --
     with out_tab as
        (select distinct to_number(regexp_substr(str, '[^,]+', 1, rownum, 'c', 0) default null on conversion error ) elem
           from
              (select p_in_str as str
                 from dual
              )
              connect by level <= regexp_count(str, '[^,]+')
        )
     select distinct listagg(elem, ',') within group(order by elem) end
       into v_out
       from out_tab;
     --
     return v_out;
   end;
   --
begin
   --cleaning
   v_list_of_sets := replace(v_list_of_sets, ' ', '') ;
   v_list_of_sets := sort_set(v_list_of_sets) ;
   --
   <<loop_through_set>>
   while regexp_count(v_list_of_sets, '[^,]+') > 0
   loop
      v_set_1 := regexp_substr(v_list_of_sets, '[^,]+', 1, 1) ;
      v_list_of_sets := regexp_replace(v_list_of_sets,v_set_1,'',1,1);
      --
      <<loop_for>>
      for i in 1..regexp_count(v_list_of_sets, '[^,]+')
      loop
         v_set_2_gr := nvl(v_set_2,v_set_1);
         v_set_2 := regexp_substr(v_list_of_sets, '[^,]+', 1, 1) ;
         --
        if to_number(v_set_2) > to_number(v_set_1) + i then
           v_output := v_output||' ['||v_set_1||case when v_set_1 != v_set_2_gr then ','||v_set_2_gr end||']';
           continue loop_through_set;
         end if;
         --
         v_list_of_sets := regexp_replace(v_list_of_sets,v_set_2,'',1,1);
         --
      end loop loop_for;
      --
      v_output := v_output||' ['||v_set_1||case when v_set_1 != v_set_2 then ','||v_set_2 end||']';
      v_list_of_sets := regexp_replace(v_list_of_sets,v_set_1,'',1,1);
      --
   end loop loop_through_set;
   --
   --output format
   v_output := nvl(v_output,'[]');
   if p_format = 1  then
      v_output := ltrim(trim(v_output), '[');
      v_output := rtrim(v_output, ']');
      v_output := replace(v_output, ',', '-');
      v_output := replace(v_output, '] [', ',');
   end if;
   --
   return trim(v_output);
end;

--Test
select '-- Test, Standart Format ' as output from dual
union all
select lpad(', ',125) || ' ==> ' || range_extraction(', ') as output from dual
union all
select lpad('0,-1,2,-2',125) || ' ==> ' || range_extraction('0,-1,2,-2') as output from dual
union all
select lpad('3,3,0,0,-2,-2',125) || ' ==> ' || range_extraction('3,3,0,0,-2,-2') as output from dual
union all
select lpad('+0,-X,swde,  2q, +4, 3,0  ,-0,-2  ,  -3',125) || ' ==> ' || range_extraction('+0,-X,swde,  2q, +4, 3,0  ,-0,-2  ,  -3') as output from dual
union all
select lpad('-1,-11,-12,-14,-15,-16,-17,-18,-19,-2,-20,-21,-22,-23,-24,-25,-0,-27,-28,-29,-30,-31,-32,-33,-35,-36,-37,-38,-39,-4,-6,-7,-8',125) || ' ==> ' || range_extraction('-1,-11,-12,-14,-15,-16,-17,-18,-19,-2,-20,-21,-22,-23,-24,-25,-0,-27,-28,-29,-30,-31,-32,-33,-35,-36,-37,-38,-39,-4,-6,-7,-8') as output from dual
union all
select lpad('1,11,12,14,15,16,17,18,19,2,20,21,22,23,24,25,0,27,28,29,30,31,32,33,35,36,37,38,39,4,6,7,8',125) || ' ==> ' || range_extraction('1,11,12,14,15,16,17,18,19,2,20,21,22,23,24,25,0,27,28,29,30,31,32,33,35,36,37,38,39,4,6,7,8') as output from dual
union all
--Test RosettaCode
select '-- Test RosettaCode, Standart Format ' as output from dual
union all
select lpad('-6, -3, -2, -1, 0, 1, 3, 4, 5, 7, 8, 9, 10, 11, 14, 15, 17, 18, 19, 20',125) || ' ==> ' || range_extraction('-6, -3, -2, -1, 0, 1, 3, 4, 5, 7, 8, 9, 10, 11, 14, 15, 17, 18, 19, 20') as output from dual
union all
select lpad('0,1,2,4,6,7,8,11,12,14,15,16,17,18,19,20,21,22,23,24,25,27,28,29,30,31,32,33,35,36,37,38,39',125) || ' ==> ' || range_extraction('0,1,2,4,6,7,8,11,12,14,15,16,17,18,19,20,21,22,23,24,25,27,28,29,30,31,32,33,35,36,37,38,39') as output from dual
union all
select '-- Test RosettaCode, RosettaCode Format' as output from dual
union all
select lpad('-6, -3, -2, -1, 0, 1, 3, 4, 5, 7, 8, 9, 10, 11, 14, 15, 17, 18, 19, 20',125) || ' ==> ' || range_extraction('-6, -3, -2, -1, 0, 1, 3, 4, 5, 7, 8, 9, 10, 11, 14, 15, 17, 18, 19, 20',1) as output from dual
union all
select lpad('0,1,2,4,6,7,8,11,12,14,15,16,17,18,19,20,21,22,23,24,25,27,28,29,30,31,32,33,35,36,37,38,39',125) || ' ==> ' || range_extraction('0,1,2,4,6,7,8,11,12,14,15,16,17,18,19,20,21,22,23,24,25,27,28,29,30,31,32,33,35,36,37,38,39',1) as output from dual
;
