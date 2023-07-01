program arithmetic(input, output)

var
 a, b: integer;

begin
 readln(a, b);
 writeln('a+b = ', a+b);
 writeln('a-b = ', a-b);
 writeln('a*b = ', a*b);
 writeln('a/b = ', a div b, ', remainder ', a mod b);
 writeln('a^b = ',Power(a,b):4:2);    {real power}
 writeln('a^b = ',IntPower(a,b):4:2); {integer power}
end.
