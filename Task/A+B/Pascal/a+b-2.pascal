var
   a, b: integer;
begin
   reset(input, 'input.txt');
   rewrite(output, 'output.txt');
   readln(a, b);
   writeln(a + b);
   close(input);
   close(output);
end.
