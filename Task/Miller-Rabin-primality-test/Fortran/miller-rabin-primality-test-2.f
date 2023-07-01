program TestMiller
  use Miller_Rabin
  implicit none

  integer, parameter :: prec = 30
  integer(huge) :: i

  ! this is limited since we're not using a bignum lib
  call do_test( (/ (i, i=1, 29) /) )

contains

  subroutine do_test(a)
    integer(huge), dimension(:), intent(in) :: a

    integer               :: i

    do i = 1, size(a,1)
       print *, a(i), miller_rabin_test(a(i), prec)
    end do

  end subroutine do_test

end program TestMiller
