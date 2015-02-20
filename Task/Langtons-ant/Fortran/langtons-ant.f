program langtons_ant
  implicit none

  integer,        parameter :: dp   = selected_real_kind(15,300)
  real(kind=dp),  parameter :: pi   = 3.1415926535897932_dp

  integer,  parameter                   :: grid_size  = 100
  integer,  dimension(:,:), allocatable :: grid
  integer,  dimension(3)                :: ant        = (/ grid_size/2, grid_size/2, 0 /)
  integer                               :: i

  allocate(grid(1:grid_size, 1:grid_size))
  grid = 1 !Grid initially white

  do
    grid(ant(1) , ant(2)) = -grid(ant(1) , ant(2))      ! Flip the color of the current square
    ant(3) = modulo(ant(3) + grid(ant(1),ant(2)),4)     ! Rotate the ant depending on the current square
    ant(1) = ant(1) + nint( sin(ant(3) * pi / 2.0_dp) ) ! Move the ant in x
    ant(2) = ant(2) + nint( cos(ant(3) * pi / 2.0_dp) ) ! Move the ant in y

    !exit if the ant is outside the grid
    if (((ant(1) < 1) .or. (ant(1) > grid_size)) .or. ((ant(2) < 1) .or. (ant(2) > grid_size))) exit

  end do

  !Print out the final grid
  open(unit=21, file="ant.dat")
  do i = 1, grid_size
    write(21,*) int(grid(:,i) + 1 / 2.0_dp)
  end do
  close(21)

  deallocate(grid)

end program langtons_ant
