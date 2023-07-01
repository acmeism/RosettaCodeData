function gcd(v, t)
  integer :: gcd
  integer, intent(in) :: v, t
  integer :: c, b, a

  b = t
  a = v
  do
     c = mod(a, b)
     if ( c == 0) exit
     a = b
     b = c
  end do
  gcd = b ! abs(b)
end function gcd
