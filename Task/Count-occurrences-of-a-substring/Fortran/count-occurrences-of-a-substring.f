program Example
  implicit none
  integer :: n

  n = countsubstring("the three truths", "th")
  write(*,*) n
  n = countsubstring("ababababab", "abab")
  write(*,*) n
  n = countsubstring("abaabba*bbaba*bbab", "a*b")
  write(*,*) n

contains

function countsubstring(s1, s2) result(c)
  character(*), intent(in) :: s1, s2
  integer :: c, p, posn

  c = 0
  if(len(s2) == 0) return
  p = 1
  do
    posn = index(s1(p:), s2)
    if(posn == 0) return
    c = c + 1
    p = p + posn + len(s2) - 1
  end do
end function
end program
