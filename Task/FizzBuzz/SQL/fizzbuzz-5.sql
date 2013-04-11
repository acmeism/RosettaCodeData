declare
  v_count integer;

begin
  for v_count in 1..100 loop
    if(mod(v_count, 15) = 0) then
      dbms_output.put_line('Fizz Buzz');
    elsif(mod(v_count, 3) = 0) then
      dbms_output.put_line('Fizz');
    elsif(mod(v_count, 5) = 0) then
      dbms_output.put_line('Buzz');
    else
      dbms_output.put_line(v_count);
    end if;
  end loop;
end;
