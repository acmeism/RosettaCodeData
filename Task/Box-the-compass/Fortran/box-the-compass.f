Program Compass
  implicit none

  integer :: i, ind
  real :: heading

  do i = 0, 32
    heading = i * 11.25
    if (mod(i, 3) == 1) then
      heading = heading + 5.62
    else if (mod(i, 3) == 2) then
            heading = heading - 5.62
    end if
    ind = mod(i, 32) + 1
    write(*, "(i2, a20, f8.2)") ind, compasspoint(heading), heading
  end do

contains

function compasspoint(h)
  character(18) :: compasspoint
  character(18) :: points(32) = (/ "North             ", "North by east     ", "North-northeast   ", &
             "Northeast by north", "Northeast         ", "Northeast by east ", "East-northeast    ", &
             "East by north     ", "East              ", "East by south     ", "East-southeast    ", &
             "Southeast by east ", "Southeast         ", "Southeast by south", "South-southeast   ", &
             "South by east     ", "South             ", "South by west     ", "South-southwest   ", &
             "Southwest by south", "Southwest         ", "Southwest by west ", "West-southwest    ", &
             "West by south     ", "West              ", "West by north     ", "West-northwest    ", &
             "Northwest by west ", "Northwest         ", "Northwest by north", "North-northwest   ", &
             "North by west     "  /)
  real, intent(in) :: h
  real :: x

  x = h / 11.25 + 1.5
  if (x >= 33.0) x = x - 32.0
  compasspoint = points(int(x))
end function compasspoint
end program Compass
