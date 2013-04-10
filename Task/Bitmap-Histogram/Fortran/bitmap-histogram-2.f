program BasicImageTests
  use RCImageBasic
  use RCImageIO
  use RCImageProcess

  implicit none

  type(rgbimage) :: animage
  type(scimage) :: gray
  integer, dimension(0:255) :: histo
  integer :: ml

  open(unit=10, file='lenna.ppm', action='read', status='old')
  call read_ppm(10, animage)
  close(10)

  call init_img(gray)
  ! or
  ! call alloc_img(gray, animage%width, animage%height)

  gray = animage

  call get_histogram(gray, histo)
  ml = histogram_median(histo)
  where ( gray%channel >= ml )
     animage%red = 255
     animage%green = 255
     animage%blue = 255
  elsewhere
     animage%red = 0
     animage%green = 0
     animage%blue = 0
  end where

  open(unit=10, file='elaborated.ppm', action='write')
  call output_ppm(10, animage)
  close(10)

  call free_img(animage)
  call free_img(gray)

end program BasicImageTests
