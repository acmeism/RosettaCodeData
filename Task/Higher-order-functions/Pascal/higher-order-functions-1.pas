program example(output);

function first(function f(x: real): real): real;
 begin
  first := f(1.0) + 2.0;
 end;

function second(x: real): real;
 begin
  second := x/2.0;
 end;

begin
 writeln(first(second));
end.
