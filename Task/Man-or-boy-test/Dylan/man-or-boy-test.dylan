define method a
    (k :: <integer>, x1 :: <function>, x2 :: <function>, x3 :: <function>,
                     x4 :: <function>, x5 :: <function>)
 => (i :: <integer>)

  local b() => (i :: <integer>)
    k := k - 1;
    a(k, b, x1, x2, x3, x4)
  end;

  if (k <= 0) x4() + x5() else b() end if

end method a;

define method man-or-boy
    (x :: <integer>)
 => (i :: <integer>)

  a(x, method()  1 end,
       method() -1 end,
       method() -1 end,
       method()  1 end,
       method()  0 end)

end method man-or-boy;

format-out("%d\n", man-or-boy(10))
