program example;

type
   FnType = function(x: real): real;

function first(f: FnType): real;
begin
   first := f(1.0) + 2.0;
end;

{$F+}
function second(x: real): real;
begin
   second := x/2.0;
end;
{$F-}

begin
   writeln(first(second));
end.
