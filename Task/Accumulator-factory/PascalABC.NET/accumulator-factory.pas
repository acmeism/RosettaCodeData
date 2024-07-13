function foo(n: real): real -> real :=
  i -> begin
    n += i;
    Result := n;
  end;

begin
  var x := foo(1);
  x(5);
  foo(3);
  print(x(2.3));
end.
