program ImageDifference

  use RCImageBasic
  use RCImageIO

  implicit none

  integer, parameter :: input1_u = 20, &
                        input2_u = 21

  type(rgbimage) :: lenna1, lenna2
  real           :: totaldiff


  open(input1_u, file="Lenna100.ppm", action="read")
  open(input2_u, file="Lenna50.ppm", action="read")
  call read_ppm(input1_u, lenna1)
  call read_ppm(input2_u, lenna2)
  close(input1_u)
  close(input2_u)

  totaldiff = sum(  (abs(lenna1%red - lenna2%red) + &
                     abs(lenna1%green - lenna2%green) + &
                     abs(lenna1%blue - lenna2%blue)) / 255.0 )


  print *, 100.0 * totaldiff / (lenna1%width * lenna1%height * 3.0)

  call free_img(lenna1)
  call free_img(lenna2)

end program ImageDifference
