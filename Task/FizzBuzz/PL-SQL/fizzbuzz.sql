begin
  for i in 1 .. 100
  loop
    case
    when mod(i, 15) = 0 then
      dbms_output.put_line('FizzBuzz');
    when mod(i, 5) = 0 then
      dbms_output.put_line('Buzz');
    when mod(i, 3) = 0 then
      dbms_output.put_line('Fizz');
    else
      dbms_output.put_line(i);
    end case;
  end loop;
end;
