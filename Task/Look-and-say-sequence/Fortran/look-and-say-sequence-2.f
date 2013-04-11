program LookAndSayTest
  use LookAndSay
  implicit none

  integer :: i
  character(len=200) :: t, r
  t = "1"
  print *,trim(t)
  call look_and_say(t, r)
  print *, trim(r)
  do i = 1, 10
     call look_and_say(r, t)
     r = t
     print *, trim(r)
  end do

end program LookAndSayTest
