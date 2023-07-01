module RCImageArea
  use RCImageBasic
  use RCImagePrimitive
  implicit none

  real, parameter, private :: matchdistance = 0.2

  private :: northsouth, eastwest

contains

  subroutine northsouth(img, p0, tcolor, fcolor)
    type(rgbimage), intent(inout) :: img
    type(point), intent(in) :: p0
    type(rgb), intent(in) :: tcolor, fcolor

    integer :: npy, spy, y
    type(rgb) :: pc

    npy = p0%y - 1
    do
       if ( inside_image(img, p0%x, npy) ) then
          call get_pixel(img, p0%x, npy, pc)
          if ( ((pc .dist. tcolor) > matchdistance ) .or. ( pc == fcolor ) ) exit
       else
          exit
       end if
       npy = npy - 1
    end do
    npy = npy + 1
    spy = p0%y + 1
    do
       if ( inside_image(img, p0%x, spy) ) then
          call get_pixel(img, p0%x, spy, pc)
          if ( ((pc .dist. tcolor) > matchdistance ) .or. ( pc == fcolor ) ) exit
       else
          exit
       end if
       spy = spy + 1
    end do
    spy = spy - 1
    call draw_line(img, point(p0%x, spy), point(p0%x, npy), fcolor)

    do y = min(spy, npy), max(spy, npy)
       if ( y == p0%y ) cycle
       call eastwest(img, point(p0%x, y), tcolor, fcolor)
    end do

  end subroutine northsouth


  subroutine eastwest(img, p0, tcolor, fcolor)
    type(rgbimage), intent(inout) :: img
    type(point), intent(in) :: p0
    type(rgb), intent(in) :: tcolor, fcolor

    integer :: npx, spx, x
    type(rgb) :: pc

    npx = p0%x - 1
    do
       if ( inside_image(img, npx, p0%y) ) then
          call get_pixel(img, npx, p0%y, pc)
          if ( ((pc .dist. tcolor) > matchdistance ) .or. ( pc == fcolor ) ) exit
       else
          exit
       end if
       npx = npx - 1
    end do
    npx = npx + 1
    spx = p0%x + 1
    do
       if ( inside_image(img, spx, p0%y) ) then
          call get_pixel(img, spx, p0%y, pc)
          if ( ((pc .dist. tcolor) > matchdistance ) .or. ( pc == fcolor ) ) exit
       else
          exit
       end if
       spx = spx + 1
    end do
    spx = spx - 1
    call draw_line(img, point(spx, p0%y), point(npx, p0%y), fcolor)

    do x = min(spx, npx), max(spx, npx)
       if ( x == p0%x ) cycle
       call northsouth(img, point(x, p0%y), tcolor, fcolor)
    end do

  end subroutine eastwest

  subroutine floodfill(img, p0, tcolor, fcolor)
    type(rgbimage), intent(inout) :: img
    type(point), intent(in) :: p0
    type(rgb), intent(in) :: tcolor, fcolor

    type(rgb) :: pcolor

    if ( .not. inside_image(img, p0%x, p0%y) ) return
    call get_pixel(img, p0%x, p0%y, pcolor)
    if ( (pcolor .dist. tcolor) > matchdistance ) return

    call northsouth(img, p0, tcolor, fcolor)
    call eastwest(img, p0, tcolor, fcolor)
  end subroutine floodfill

end module RCImageArea
