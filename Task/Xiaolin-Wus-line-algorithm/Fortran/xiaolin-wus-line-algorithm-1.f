program xiaolin_wu_line_algorithm
  use, intrinsic :: ieee_arithmetic
  implicit none

  type :: drawing_surface
     integer :: u0, v0, u1, v1
     real, allocatable :: pixels(:)
  end type drawing_surface

  interface
     subroutine point_plotter (s, x, y, opacity)
       import drawing_surface
       type(drawing_surface), intent(inout) :: s
       integer, intent(in) :: x, y
       real, intent(in) :: opacity
     end subroutine point_plotter
  end interface

  real, parameter :: pi = 4.0 * atan (1.0)

  integer, parameter :: u0 = -499
  integer, parameter :: v0 = -374
  integer, parameter :: u1 = 500
  integer, parameter :: v1 = 375

  real, parameter :: a = 200.0  ! Ellipse radius on x axis.
  real, parameter :: b = 350.0  ! Ellipse radius on y axis.

  type(drawing_surface) :: s
  integer :: i, step_size
  real :: t, c, d
  real :: x, y
  real :: xnext, ynext
  real :: u, v
  real :: rhs, ad, bc
  real :: x0, y0, x1, y1

  s = make_drawing_surface (u0, v0, u1, v1)

  ! Draw both an ellipse and the normals of that ellipse.
  step_size = 2
  do i = 0, 359, step_size
     ! Parametric representation of an ellipse.
     t = i * (pi / 180.0)
     c = cos (t)
     d = sin (t)
     x = a * c
     y = b * d

     ! Draw a piecewise linear approximation of the ellipse. The
     ! endpoints of the line segments will lie on the curve.
     xnext = a * cos ((i + step_size) * (pi / 180.0))
     ynext = b * sin ((i + step_size) * (pi / 180.0))
     call draw_line (s, x, y, xnext, ynext)

     ! The parametric equation of the normal:
     !
     !   (a * sin (t) * xnormal) - (b * cos (t) * ynormal)
     !        = (a**2 - b**2) * cos (t) * sin (t)
     !
     ! That is:
     !
     !   (a * d * xnormal) - (b * c * ynormal) = (a**2 - b**2) * c * d
     !
     rhs = (a**2 - b**2) * c * d
     ad = a * d
     bc = b * c
     if (abs (ad) < abs (bc)) then
        x0 = -1000.0
        y0 = ((ad * x0) - rhs) / bc
        x1 = 1000.0
        y1 = ((ad * x1) - rhs) / bc
     else
        y0 = -1000.0
        x0 = (rhs - (bc * y0)) / ad
        y1 = 1000.0
        x1 = (rhs - (bc * y1)) / ad
     end if

     call draw_line (s, x0, y0, x1, y1)
  end do

  call write_transparency_mask (s)

contains

  function make_drawing_surface (u0, v0, u1, v1) result (s)
    integer, intent(in) :: u0, v0, u1, v1
    type(drawing_surface) :: s

    integer :: w, h

    if (u1 < u0 .or. v1 < v0) error stop
    s%u0 = u0; s%v0 = v0
    s%u1 = u1; s%v1 = v1
    w = u1 - u0 + 1
    h = v1 - v0 + 1
    allocate (s%pixels(0:(w * h) - 1), source = 0.0)
  end function make_drawing_surface

  function drawing_surface_ref (s, x, y) result (c)
    type(drawing_surface), intent(in) :: s
    integer, intent(in) :: x, y
    real :: c

    ! In calls to drawing_surface_ref and drawing_surface_set, indices
    ! outside the drawing_surface are allowed. Such indices are
    ! treated as if you were trying to draw on the air.

    if (s%u0 <= x .and. x <= s%u1 .and. s%v0 <= y .and. y <= s%v1) then
       c = s%pixels((x - s%u0) + ((s%v1 - y) * (s%u1 - s%u0 + 1)))
    else
       c = ieee_value (s%pixels(0), ieee_quiet_nan)
    end if
  end function drawing_surface_ref

  subroutine drawing_surface_set (s, x, y, c)
    type(drawing_surface), intent(inout) :: s
    integer, intent(in) :: x, y
    real, intent(in) :: c

    ! In calls to drawing_surface_ref and drawing_surface_set, indices
    ! outside the drawing_surface are allowed. Such indices are
    ! treated as if you were trying to draw on the air.

    if (s%u0 <= x .and. x <= s%u1 .and. s%v0 <= y .and. y <= s%v1) then
       s%pixels((x - s%u0) + ((s%v1 - y) * (s%u1 - s%u0 + 1))) = c
    end if
  end subroutine drawing_surface_set

  subroutine write_transparency_mask (s)
    type(drawing_surface), intent(in) :: s

    ! Write a transparency mask, in plain (ASCII or EBCDIC) Portable
    ! Gray Map format, but representing opacities rather than
    ! whitenesses. (Thus there will be no need for gamma corrections.)
    ! See the pgm(5) manpage for a discussion of this use of PGM
    ! format.

    integer :: w, h
    integer :: i

    w = s%u1 - s%u0 + 1
    h = s%v1 - s%v0 + 1

    write (*, '("P2")')
    write (*, '("# transparency mask")')
    write (*, '(I0, 1X, I0)') w, h
    write (*, '("255")')
    write (*, '(15I4)') (nint (255 * s%pixels(i)), i = 0, (w * h) - 1)
  end subroutine write_transparency_mask

  subroutine draw_line (s, x0, y0, x1, y1)
    type(drawing_surface), intent(inout) :: s
    real, intent(in) :: x0, y0, x1, y1

    real :: xdiff, ydiff

    xdiff = abs (x1 - x0)
    ydiff = abs (y1 - y0)
    if (ydiff <= xdiff) then
       if (x0 <= x1) then
          call drawln (s, x0, y0, x1, y1, plot_shallow)
       else
          call drawln (s, x1, y1, x0, y0, plot_shallow)
       end if
    else
       if (y0 <= y1) then
          call drawln (s, y0, x0, y1, x1, plot_steep)
       else
          call drawln (s, y1, x1, y0, x0, plot_steep)
       end if
    end if
  end subroutine draw_line

  subroutine drawln (s, x0, y0, x1, y1, plot)
    type(drawing_surface), intent(inout) :: s
    real, intent(in) :: x0, y0, x1, y1
    procedure(point_plotter) :: plot

    real :: dx, dy, gradient
    real :: yend, xgap
    real :: first_y_intersection, intery
    integer :: xend
    integer :: xpxl1, ypxl1
    integer :: xpxl2, ypxl2
    integer :: x

    dx = x1 - x0;  dy = y1 - y0
    if (dx == 0.0) then
       gradient = 1.0
    else
       gradient = dy / dx
    end if

    ! Handle the first endpoint.
    xend = iround (x0)
    yend = y0 + (gradient * (xend - x0))
    xgap = rfpart (x0 + 0.5)
    xpxl1 = xend
    ypxl1 = ipart (yend)
    call plot (s, xpxl1, ypxl1, rfpart (yend) * xgap)
    call plot (s, xpxl1, ypxl1 + 1, fpart (yend) * xgap)

    first_y_intersection = yend + gradient

    ! Handle the second endpoint.
    xend = iround (x1)
    yend = y1 + (gradient * (xend - x1))
    xgap = fpart (x1 + 0.5)
    xpxl2 = xend
    ypxl2 = ipart (yend)
    call plot (s, xpxl2, ypxl2, (rfpart (yend) * xgap))
    call plot (s, xpxl2, ypxl2 + 1, fpart (yend) * xgap)

    ! Loop over the rest of the points.
    intery = first_y_intersection
    do x = xpxl1 + 1, xpxl2 - 1
       call plot (s, x, ipart (intery), rfpart (intery))
       call plot (s, x, ipart (intery) + 1, fpart (intery))
       intery = intery + gradient
    end do
  end subroutine drawln

  subroutine plot_shallow (s, x, y, opacity)
    type(drawing_surface), intent(inout) :: s
    integer, intent(in) :: x, y
    real, intent(in) :: opacity

    real :: combined_opacity

    ! Let us simply add opacities, up to the maximum of 1.0. You might
    ! wish to do something different, of course.
    combined_opacity = opacity + drawing_surface_ref (s, x, y)
    call drawing_surface_set (s, x, y, min (combined_opacity, 1.0))
  end subroutine plot_shallow

  subroutine plot_steep (s, x, y, opacity)
    type(drawing_surface), intent(inout) :: s
    integer, intent(in) :: x, y
    real, intent(in) :: opacity
    call plot_shallow (s, y, x, opacity)
  end subroutine plot_steep

  elemental function ipart (x) result (i)
    real, intent(in) :: x
    integer :: i
    i = floor (x)
  end function ipart

  elemental function iround (x) result (i)
    real, intent(in) :: x
    integer :: i
    i = ipart (x + 0.5)
  end function iround

  elemental function fpart (x) result (y)
    real, intent(in) :: x
    real :: y
    y = modulo (x, 1.0)
  end function fpart

  elemental function rfpart (x) result (y)
    real, intent(in) :: x
    real :: y
    y = 1.0 - fpart (x)
  end function rfpart

end program xiaolin_wu_line_algorithm
