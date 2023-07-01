create function special_division(p_num double precision, p_den double precision) returns text
as $body$
begin
   return p_num/p_den::text;
EXCEPTION
   when division_by_zero then
      if p_num>0 then
         return 'Inf';
      ELSIF p_num<0 then
         return '-Inf';
      else
         return 'INDEF';
      end if;
   when others then
      raise;
end;
