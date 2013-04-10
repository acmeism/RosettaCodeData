module RCImagePrimitive
  use RCImageBasic

  implicit none

  type point
     integer :: x, y
  end type point

  private :: swapcoord

contains

  subroutine swapcoord(p1, p2)
    integer, intent(inout) :: p1, p2
    integer :: t

    t = p2
    p2 = p1
    p1 = t
  end subroutine swapcoord

  subroutine draw_line(img, from, to, color)
    type(rgbimage), intent(inout) :: img
    type(point), intent(in) :: from, to
    type(rgb), intent(in) :: color

    type(point) :: rfrom, rto
    integer :: dx, dy, error, ystep, x, y
    logical :: steep

    rfrom = from
    rto = to
    steep = (abs(rto%y - rfrom%y) > abs(rto%x - rfrom%x))
    if ( steep ) then
       call swapcoord(rfrom%x, rfrom%y)
       call swapcoord(rto%x, rto%y)
    end if
    if ( rfrom%x > rto%x ) then
       call swapcoord(rfrom%x, rto%x)
       call swapcoord(rfrom%y, rto%y)
    end if

    dx = rto%x - rfrom%x
    dy = abs(rto%y - rfrom%y)
    error = dx / 2
    y = rfrom%y

    if ( rfrom%y < rto%y ) then
       ystep = 1
    else
       ystep = -1
    end if

    do x = rfrom%x, rto%x
       if ( steep ) then
          call put_pixel(img, y, x, color)
       else
          call put_pixel(img, x, y, color)
       end if
       error = error - dy
       if ( error < 0 ) then
          y = y + ystep
          error = error + dx
       end if
    end do

  end subroutine draw_line

end module RCImagePrimitive
