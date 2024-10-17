type
  Tfuncs = integer-> () -> integer;

begin
  var captor: Tfuncs := x -> () ->x * x;
  var functions := Range(0, 10).Select(captor).ToArray;
  println(functions);
  println(functions[4]());
end.
