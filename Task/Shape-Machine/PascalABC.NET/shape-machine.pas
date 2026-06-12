begin
  var count := 0;
  var n := ReadInteger;
  var next: real := n;
  var prev: real;
  repeat
    Writeln(next);
    prev := next;
    next := (prev + 3) * 0.86;
    count += 1;
  until prev = next;
  Writeln(count);
end.
