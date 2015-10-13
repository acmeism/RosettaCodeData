program Langtons_Ant
  implicit none

  integer, parameter :: csize = 100
  integer :: direction = 0, maxsteps = 20000
  integer :: i, x, y
  logical :: cells(csize,csize) = .true.
  logical :: cflag

  x = csize / 2;   y = x

  do i = 1, maxsteps
    cflag = cells(x,y)
    if(cflag) then
      direction = direction + 1
      if(direction == 4) direction = direction - 4
    else
      direction = direction - 1
      if(direction == -1) direction = direction + 4
    end if

    cells(x,y) = .not. cells(x,y)

    select case(direction)
      case(0)
        y = y - 1
      case(1)
        x = x + 1
      case(2)
        y = y + 1
      case(3)
        x = x - 1
    end select

    if(x < 1 .or. x > csize .or. y < 1 .or. y > csize) exit
  end do

  do y = 1, csize
    do x = 1, csize
      if(cells(x,y)) then
        write(*, "(a)", advance="no") "."
      else
        write(*, "(a)", advance="no") "#"
      end if
    end do
    write(*,*)
  end do
end program
