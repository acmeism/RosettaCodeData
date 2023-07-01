fun agm(a, g) = let
  fun agm'(a, g, eps) =
    if Real.abs(a-g) < eps then
      a
    else
      agm'((a+g)/2.0, Math.sqrt(a*g), eps)
  in agm'(a, g, 1e~15)
  end;
