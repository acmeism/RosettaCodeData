module RCImageProcess
  use RCImageBasic
  implicit none
contains

  subroutine get_histogram(img, histogram)
    type(scimage), intent(in) :: img
    integer, dimension(0:255), intent(out) :: histogram

    integer :: i

    histogram = 0
    do i = 0,255
       histogram(i) = sum(img%channel, img%channel == i)
    end do
  end subroutine get_histogram

  function histogram_median(histogram)
    integer, dimension(0:255), intent(in) :: histogram
    integer :: histogram_median

    integer :: from, to, left, right

    from = 0
    to = 255
    left = histogram(from)
    right = histogram(to)
    do while ( from /= to )
       if ( left < right ) then
          from = from + 1
          left = left + histogram(from)
       else
          to = to - 1
          right = right + histogram(to)
       end if
    end do
    histogram_median = from
  end function histogram_median

end module RCImageProcess
