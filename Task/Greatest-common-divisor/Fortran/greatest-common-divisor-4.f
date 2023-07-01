subroutine gcd_bin(value, u, v)
  integer, intent(out) :: value
  integer, intent(inout) :: u, v
  integer :: k, t

  u = abs(u)
  v = abs(v)
  if( u < v ) then
     t = u
     u = v
     v = t
  endif
  if( v == 0 ) then
     value = u
     return
  endif
  k = 1
  do while( (mod(u, 2) == 0).and.(mod(v, 2) == 0) )
     u = u / 2
     v = v / 2
     k = k * 2
  enddo
  if( (mod(u, 2) == 0) ) then
     t = u
  else
     t = -v
  endif
  do while( t /= 0 )
     do while( (mod(t, 2) == 0) )
        t = t / 2
     enddo
     if( t > 0 ) then
        u = t
     else
        v = -t
     endif
     t = u - v
  enddo
  value = u * k
end subroutine gcd_bin
