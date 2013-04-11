fib := function(n)
  local a;
  a := [[0, 1], [1, 1]]^n;
  return a[1][2];
end;
