##
var x := 1;
var y := 0;
try
  var z := x div y;
except
  on System.DivideByZeroException do
    writeln('Integer division by 0');
end;
