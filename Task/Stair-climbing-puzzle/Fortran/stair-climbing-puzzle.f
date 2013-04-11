module StairRobot
  implicit none

contains

  logical function step()
    ! try to climb up and return true or false
    step = .true.     ! to avoid compiler warning
  end function step

  recursive subroutine step_up_rec
    do while ( .not. step() )
       call step_up_rec
    end do
  end subroutine step_up_rec

  subroutine step_up_iter
    integer :: i = 0
    do while ( i < 1 )
       if ( step() ) then
          i = i + 1
       else
          i = i - 1
       end if
    end do
  end subroutine step_up_iter

end module StairRobot
