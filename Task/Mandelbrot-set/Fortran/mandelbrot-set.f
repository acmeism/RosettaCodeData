program mandelbrot

  implicit none
  integer  , parameter :: rk       = selected_real_kind (9, 99)
  integer  , parameter :: i_max    =  800
  integer  , parameter :: j_max    =  600
  integer  , parameter :: n_max    =  100
  real (rk), parameter :: x_centre = -0.5_rk
  real (rk), parameter :: y_centre =  0.0_rk
  real (rk), parameter :: width    =  4.0_rk
  real (rk), parameter :: height   =  3.0_rk
  real (rk), parameter :: dx_di    =   width / i_max
  real (rk), parameter :: dy_dj    = -height / j_max
  real (rk), parameter :: x_offset = x_centre - 0.5_rk * (i_max + 1) * dx_di
  real (rk), parameter :: y_offset = y_centre - 0.5_rk * (j_max + 1) * dy_dj
  integer, dimension (i_max, j_max) :: image
  integer   :: i
  integer   :: j
  integer   :: n
  real (rk) :: x
  real (rk) :: y
  real (rk) :: x_0
  real (rk) :: y_0
  real (rk) :: x_sqr
  real (rk) :: y_sqr

  do j = 1, j_max
    y_0 = y_offset + dy_dj * j
    do i = 1, i_max
      x_0 = x_offset + dx_di * i
      x = 0.0_rk
      y = 0.0_rk
      n = 0
      do
        x_sqr = x ** 2
        y_sqr = y ** 2
        if (x_sqr + y_sqr > 4.0_rk) then
          image (i, j) = 255
          exit
        end if
        if (n == n_max) then
          image (i, j) = 0
          exit
        end if
        y = y_0 + 2.0_rk * x * y
        x = x_0 + x_sqr - y_sqr
        n = n + 1
      end do
    end do
  end do
  open  (10, file = 'out.pgm')
  write (10, '(a/ i0, 1x, i0/ i0)') 'P2', i_max, j_max, 255
  write (10, '(i0)') image
  close (10)

end program mandelbrot
