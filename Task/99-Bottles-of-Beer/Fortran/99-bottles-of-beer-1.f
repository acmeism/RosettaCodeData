program bottlestest

  implicit none

  integer :: i

  character(len=*), parameter   :: bwall = " on the wall", &
                                   bottles = "bottles of beer", &
                                   bottle  = "bottle of beer", &
                                   take = "Take one down, pass it around", &
                                   form = "(I0, ' ', A)"

  do i = 99,0,-1
     if ( i /= 1 ) then
        write (*,form)  i, bottles // bwall
        if ( i > 0 ) write (*,form)  i, bottles
     else
        write (*,form)  i, bottle // bwall
        write (*,form)  i, bottle
     end if
     if ( i > 0 ) write (*,*) take
  end do

end program bottlestest
