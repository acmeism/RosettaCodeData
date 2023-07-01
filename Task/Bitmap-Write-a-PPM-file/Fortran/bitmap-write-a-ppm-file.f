program main

  use rgbimage_m

  implicit none

  integer :: nx, ny, i, j, k

  type(rgbimage) :: im

  ! init image of height nx, width ny
  nx = 400
  ny = 300
  call im%init(nx, ny)

  ! set some random pixel data
  do i = 1, nx
    do j = 1, ny
      call im%set_pixel(i, j, [(nint(rand()*255), k=1,3)])
    end do
  end do

  ! output image into file
  call im%write('fig.ppm')

end program
