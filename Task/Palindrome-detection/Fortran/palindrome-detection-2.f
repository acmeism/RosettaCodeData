! non-recursive
function is_palindro(t)
  logical :: is_palindro
  character(len=*), intent(in) :: t

  integer :: i, l

  l = len(t)
  is_palindro = .false.
  do i=1, l/2
     if ( t(i:i) /= t(l-i+1:l-i+1) ) return
  end do
  is_palindro = .true.
end function is_palindro

! non-recursive 2
function is_palindro2(t) result(isp)
  logical :: isp
  character(len=*), intent(in) :: t

  character(len=len(t)) :: s
  integer :: i

  forall(i=1:len(t)) s(len(t)-i+1:len(t)-i+1) = t(i:i)
  isp = ( s == t )
end function is_palindro2
