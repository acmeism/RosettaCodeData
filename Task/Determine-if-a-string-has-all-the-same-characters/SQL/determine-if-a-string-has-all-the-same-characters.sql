/*
This code is an implementation of "Determination if a string has all the same characters" in SQL ORACLE 19c
p_in_str -- input string
*/
with
  function same_characters_in_string(p_in_str in varchar2) return varchar2 is
    v_que varchar2(32767) := p_in_str;
    v_res varchar2(32767);
    v_first varchar2(1);
    v_next  varchar2(1);
begin
  v_first := substr(v_que,1,1);
  if v_first is null then
    v_res := '"" length:0 all characters are the same';
  else
    for i in 2..length(v_que)
    loop
      v_next := substr(v_que,i,1);
      if v_first != v_next then
        v_res := '"'||v_que||'" length:'||length(v_que)||', first different character "'||v_next||'"(0x'||rawtohex(utl_raw.cast_to_raw(v_next))||') at position:'|| i;
        exit;
      end if;
   end loop;
   v_res := nvl(v_res,'"'||v_que||'" length:'||length(v_que)||' all characters are the same');
  end if;
  return v_res;
end;

--Test
select same_characters_in_string('') as res from dual
union all
select same_characters_in_string('   ') as res from dual
union all
select same_characters_in_string('2') as res from dual
union all
select same_characters_in_string('333') as res from dual
union all
select same_characters_in_string('.55') as res from dual
union all
select same_characters_in_string('tttTTT') as res from dual
union all
select same_characters_in_string('4444 444k') as res from dual
;
