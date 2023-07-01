subroutine cubic_bezier(img, p1, p2, p3, p4, color)
  type(rgbimage), intent(inout) :: img
  type(point), intent(in) :: p1, p2, p3, p4
  type(rgb), intent(in) :: color

  integer :: i, j
  real :: pts(0:N_SEG,0:1), t, a, b, c, d, x, y

  do i = 0, N_SEG
     t = real(i) / real(N_SEG)
     a = (1.0 - t)**3.0
     b = 3.0 * t * (1.0 - t)**2
     c = 3.0 * (1.0 - t) * t**2
     d = t**3.0
     x = a * p1%x + b * p2%x + c * p3%x + d * p4%x
     y = a * p1%y + b * p2%y + c * p3%y + d * p4%y
     pts(i,0) = x
     pts(i,1) = y
  end do

  do i = 0, N_SEG-1
     j = i + 1
     call draw_line(img, point(pts(i,0), pts(i,1)), &
                    point(pts(j,0), pts(j,1)), color)
  end do

end subroutine cubic_bezier
