  function x=a(x)
    printf('a: %i\n',x);	
  end;
  function x=b(x)
    printf('b: %i\n',x);
  end;

  a(1) && b(1)
  a(0) && b(1)
  a(1) || b(1)
  a(0) || b(1)
