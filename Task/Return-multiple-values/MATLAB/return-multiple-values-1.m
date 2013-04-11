  function [a,b,c]=foo(d)
    a = 1-d;
    b = 2+d;
    c = a+b;
  end;
  [x,y,z] = foo(5)
