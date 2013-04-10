program BasicImageTests
  use RCImageBasic
  use RCImageIO
  use RCImagePrimitive

  implicit none

  type(rgbimage) :: animage
  integer :: x, y

  call alloc_img(animage, 200, 200)
  call fill_img(animage, rgb(255,255,255))

  call draw_line(animage, point(0,0), point(199,199), rgb(0,0,0))

  do y=0,219,20
     call draw_line(animage, point(0,0), point(199, y), &
                    rgb(0,0,0))
  end do

  open(unit=10, file='outputimage.ppm', status='new')
  call output_ppm(10, animage)
  close(10)

  call free_img(animage)

end program BasicImageTests
