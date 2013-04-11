module MutualRec
  implicit none
contains
  pure recursive function m(n) result(r)
    integer :: r
    integer, intent(in) :: n
    if ( n == 0 ) then
       r = 0
       return
    end if
    r = n - f(m(n-1))
  end function m

  pure recursive function f(n) result(r)
    integer :: r
    integer, intent(in) :: n
    if ( n == 0 ) then
       r = 1
       return
    end if
    r = n - m(f(n-1))
  end function f

end module
