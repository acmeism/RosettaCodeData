program main

  use rgbimage_m
  use abelian_sandpile_m

  implicit none

  integer :: nx, ny, i, j

  integer :: colors(0:3,3)

  type(rgbimage) :: im
  type(pile) :: p

  colors(0,:) = [255,255,255]
  colors(1,:) = [0,0,90]
  colors(2,:) = [0,0,170]
  colors(3,:) = [0,0,255]

  nx = 200
  ny = 100

  call p%init(nx, ny, 2000)
  call p%run

  call im%init(nx, ny)

  do i = 1, nx
    do j = 1, ny
      call im%set_pixel(i, j, colors(p%grid(i,j),:))
    end do
  end do

  call im%write('fig.ppm')

end program
