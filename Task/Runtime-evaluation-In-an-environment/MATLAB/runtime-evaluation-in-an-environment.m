function r = calcit(f, val1, val2)
  x = val1;
  a = eval(f);
  x = val2;
  b = eval(f);
  r = b-a;
end
