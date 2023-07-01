subroutine plot(ch, p, v)
  integer, dimension(:,:), intent(out) :: ch
  type(point), intent(in) :: p
  integer, intent(in) :: v

  integer :: cx, cy
  ! I've kept the default 1-based array, but top-left corner pixel
  ! is labelled as (0,0).
  cx = p%x + 1
  cy = p%y + 1

  if ( (cx > 0) .and. (cx <= ubound(ch,1)) .and. &
       (cy > 0) .and. (cy <= ubound(ch,2)) ) then
     ch(cx,cy) = v
  end if
end subroutine plot

subroutine draw_circle_toch(ch, c, radius, v)
  integer, dimension(:,:), intent(out) :: ch
  type(point), intent(in) :: c
  integer, intent(in) :: radius, v

  integer :: f, ddf_x, ddf_y, x, y

  f = 1 - radius
  ddf_x = 0
  ddf_y = -2 * radius
  x = 0
  y = radius

  call plot(ch, point(c%x, c%y + radius), v)
  call plot(ch, point(c%x, c%y - radius), v)
  call plot(ch, point(c%x + radius, c%y), v)
  call plot(ch, point(c%x - radius, c%y), v)

  do while ( x < y )
     if ( f >= 0 ) then
        y = y - 1
        ddf_y = ddf_y + 2
        f = f + ddf_y
     end if
     x = x + 1
     ddf_x = ddf_x + 2
     f = f + ddf_x + 1
     call plot(ch, point(c%x + x, c%y + y), v)
     call plot(ch, point(c%x - x, c%y + y), v)
     call plot(ch, point(c%x + x, c%y - y), v)
     call plot(ch, point(c%x - x, c%y - y), v)
     call plot(ch, point(c%x + y, c%y + x), v)
     call plot(ch, point(c%x - y, c%y + x), v)
     call plot(ch, point(c%x + y, c%y - x), v)
     call plot(ch, point(c%x - y, c%y - x), v)
  end do

end subroutine draw_circle_toch

subroutine draw_circle_rgb(img, c, radius, color)
  type(rgbimage), intent(out) :: img
  type(point), intent(in) :: c
  integer, intent(in) :: radius
  type(rgb), intent(in) :: color

  call draw_circle_toch(img%red, c, radius, color%red)
  call draw_circle_toch(img%green, c, radius, color%green)
  call draw_circle_toch(img%blue, c, radius, color%blue)
end subroutine draw_circle_rgb

subroutine draw_circle_sc(img, c, radius, lum)
  type(scimage), intent(out) :: img
  type(point), intent(in) :: c
  integer, intent(in) :: radius, lum

  call draw_circle_toch(img%channel, c, radius, lum)
end subroutine draw_circle_sc
