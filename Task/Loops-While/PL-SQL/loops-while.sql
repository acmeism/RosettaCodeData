set serveroutput on
declare
  n number := 1024;
begin
  while n > 0 loop
    dbms_output.put_line(n);
    n := trunc(n / 2);
  end loop;
end;
/
