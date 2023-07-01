/*
This code is an implementation of "Range expansion" in SQL ORACLE 19c
p_list_of_sets -- input string
delimeter by default ","
*/
with
function range_expansion(p_list_of_sets in varchar2)
return varchar2 is
   --
   v_list_of_sets varchar2(32767) := p_list_of_sets;
   v_output       varchar2(32767) ;
   v_set_1        varchar2(2000) ;
   v_set_1_min    pls_integer;
   v_set_1_max    pls_integer;
   --
   function sort_set(p_in_str varchar2)
   return varchar2 is
      v_out varchar2(32767) := p_in_str;
   begin
     --
     with out_tab as
        (select to_number(regexp_substr(str, '[^,]+', 1, rownum, 'c', 0) default null on conversion error) elem
           from
              (select p_in_str as str
                 from dual
              )
              connect by level <= regexp_count(str, '[^,]+')
        )
     select trim(both ',' from min(elem)||','||max(elem)) end
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
        (select distinct to_number(regexp_substr(str, '[^,]+', 1, rownum, 'c', 0) default null on conversion error) elem
           from
              (select p_in_str as str
                 from dual
              )
              connect by level <= regexp_count(str, '[^,]+')
        )
     select listagg(elem, ',') within group(order by elem) end
       into v_out
       from out_tab
     where elem is not null;
     --
     return v_out;
   end;
   --
begin
   --cleaning
   v_list_of_sets := replace(v_list_of_sets, ' ', '') ;
   v_list_of_sets := replace(v_list_of_sets, '+', '') ;
   v_list_of_sets := replace(v_list_of_sets, ',', '|') ;
   v_list_of_sets := regexp_replace(v_list_of_sets, '(\d{1,})-(\d{1,})', '\1,\2', 1, 0) ;
   v_list_of_sets := regexp_replace(v_list_of_sets, '(\d{1,})--(\d{1,})', '\1,-\2', 1, 0) ;
   --
   <<loop_through_sets>>
   while regexp_count(v_list_of_sets, '[^|]+') > 0
   loop
      v_set_1 := regexp_substr(v_list_of_sets, '[^|]+', 1, 1) ;
      v_list_of_sets := regexp_replace(v_list_of_sets, v_set_1, sort_set(v_set_1), 1, 1) ;
      v_set_1 := sort_set(v_set_1) ;
      --
      continue loop_through_sets when v_set_1 is null;
      --
      v_set_1_min := least(to_number(regexp_substr(v_set_1, '[^,]+', 1, 1))
                          ,to_number(regexp_substr(v_set_1, '[^,]+', 1, 2))
                          ) ;
      v_set_1_max := greatest(to_number(regexp_substr(v_set_1, '[^,]+', 1, 1))
                             ,to_number(regexp_substr(v_set_1, '[^,]+', 1, 2))
                             ) ;
      --
      <<loop_for>>
      for i in v_set_1_min..v_set_1_max
      loop
         --
         v_output := v_output||','||i;
         --
      end loop loop_for;
      --
      v_list_of_sets := regexp_replace(v_list_of_sets,v_set_1,'',1,1);
      --
   end loop loop_through_sets;
   --
   v_output := sort_output(v_output);
   --
   return trim(v_output);
end;

--Test
select '-- Test ' as output from dual
union all
select lpad(' ', 65) || ' ==> ' || range_expansion(' ') as output from dual
union all
select lpad('-0,+0,-2  ,-1--2,3  ,-3, 2,-2', 65) || ' ==> ' || range_expansion('-0,+0,-2  ,-1--2,3  ,-3, 2,-2') as output from dual
union all
select lpad('0,-1,+2,-2', 65) || ' ==> ' || range_expansion('0,-1,2,-2') as output from dual
union all
select lpad('-D,-w23--1,+14q,15,17-20,3-5,7-11, +0, 2q, +4, 3,0  ,-0,-2 , -3', 65) || ' ==> ' || range_expansion('-D,-w23--1,+14q,15,17-20,3-5,7-11, +0, 2q, +4, 3,0  ,-0,-2  ,  -3') as output from dual
union all
select lpad('-6,-3--1,14,15,17-20,3-5,7-11', 65) || ' ==> ' || range_expansion('-6,-3--1,14,15,17-20,3-5,11-7') as output from dual
union all
--Test RosettaCode
select '-- Test RosettaCode' as output from dual
union all
select lpad('-6,-3--1,3-5,7-11,14,15,17-20', 65) || ' ==> ' || range_expansion('-6,-3--1,3-5,7-11,14,15,17-20') as output from dual
;
