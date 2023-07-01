/*
This is a code implementation for finding one or more contiguous subsequences in a general sequence with the maximum sum of its elements.
p_list      -- List of elements of the general sequence of integers separated by a delimiter.
p_delimiter -- proper delimiter
*/

with
  function greatest_subsequential_sum(p_list in varchar2, p_delimiter in varchar2) return varchar2 is
    -- Variablen
    v_list       varchar2(32767) := trim(both p_delimiter from p_list);
    v_substr_i   varchar2(32767);
    v_substr_j   varchar2(32767);
    v_substr_out varchar2(32767);
    v_res        integer := 0;
    v_res_out    integer := 0;
    --
  begin
     --
     v_list := regexp_replace(v_list,''||chr(92)||p_delimiter||'{2,}',p_delimiter);
     --
     for i in 1..nvl(regexp_count(v_list,'[^'||p_delimiter||']+'),0)
     loop
       v_substr_i := substr(v_list,regexp_instr(v_list,'[^'||p_delimiter||']+',1,i));
       --
       for j in reverse 1..regexp_count(v_substr_i,'[^'||p_delimiter||']+')
       loop
         --
         v_substr_j := trim(both p_delimiter from substr(v_substr_i,1,regexp_instr(v_substr_i,'[^'||p_delimiter||']+',1,j,1)));
         execute immediate 'select sum('||replace(v_substr_j,p_delimiter,'+')||') from dual' into v_res;
         --
         if v_res > v_res_out then
            v_res_out := v_res;
            v_substr_out := '{'||v_substr_j||'}';
         elsif v_res = v_res_out then
            v_res_out := v_res;
            v_substr_out := v_substr_out||',{'||v_substr_j||'}';
         end if;
         --
      end loop;
      --
   end loop;
   --
   v_substr_out := trim(both ',' from nvl(v_substr_out,'{}'));
   v_substr_out := case when regexp_count(v_substr_out,'},{')>0 then 'subsequences '||v_substr_out else 'a subsequence '||v_substr_out end;
   return 'The maximum sum '||v_res_out||' belongs to '||v_substr_out||' of the main sequence {'||p_list||'}';
end;

--Test
select greatest_subsequential_sum('-1|-2|-3|-4|-5|', '|') as "greatest subsequential sum" from dual
union all
select greatest_subsequential_sum('', '') from dual
union all
select greatest_subsequential_sum('     ', ' ') from dual
union all
select greatest_subsequential_sum(';;;;;;+1;;;;;;;;;;;;;2;+3;4;;;;-5;;;;', ';') from dual
union all
select greatest_subsequential_sum('-1,-2,+3,,,,,,,,,,,,+5,+6,-2,-1,+4,-4,+2,-1', ',') from dual
union all
select greatest_subsequential_sum(',+7,-6,-8,+5,-2,-6,+7,+4,+8,-9,-3,+2,+6,-4,-6,,', ',') from dual
union all
select greatest_subsequential_sum('01 +2 3 +4 05 -8 -9 -20 40 25 -5', ' ') from dual
union all
select greatest_subsequential_sum('1 2 3 0 0  -99 02 03 00001 -99 3 2 1 -99 3 1 2 0', ' ') from dual
union all
select greatest_subsequential_sum('0,0,1,0', ',') from dual
union all
select greatest_subsequential_sum('0,0,0', ',') from dual
union all
select greatest_subsequential_sum('1,-1,+1', ',') from dual;
