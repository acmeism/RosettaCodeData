subroutine quad_bezier(img, p1, p2, p3, color)
  type(rgbimage), intent(inout) :: img
  type(point), intent(in) :: p1, p2, p3
  type(rgb), intent(in) :: color

  integer :: i, j
  real :: pts(0:N_SEG,0:1), t, a, b, c, x, y

  do i = 0, N_SEG
     t = real(i) / real(N_SEG)
     a = (1.0 - t)**2.0
     b = 2.0 * t * (1.0 - t)
     c = t**2.0
     x = a * p1%x + b * p2%x + c * p3%x
     y = a * p1%y + b * p2%y + c * p3%y
     pts(i,0) = x
     pts(i,1) = y
  end do

  do i = 0, N_SEG-1
     j = i + 1
     call draw_line(img, point(pts(i,0), pts(i,1)), &
                    point(pts(j,0), pts(j,1)), color)
  end do

end subroutine quad_bezier
