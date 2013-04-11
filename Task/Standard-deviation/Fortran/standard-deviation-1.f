program Test_Stddev
  implicit none

  real, dimension(8) :: v = (/ 2,4,4,4,5,5,7,9 /)
  integer :: i
  real :: sd

  do i = 1, size(v)
     sd = stat_object(v(i))
  end do

  print *, "std dev = ", sd

contains

  recursive function stat_object(a, cmd) result(stddev)
    real :: stddev
    real, intent(in) :: a
    character(len=*), intent(in), optional :: cmd

    real, save :: summa = 0.0, summa2 = 0.0
    integer, save :: num = 0

    real :: m

    if ( .not. present(cmd) ) then
       num = num + 1
       summa = summa + a
       summa2 = summa2 + a*a
       stddev = stat_object(0.0, "stddev")
    else
       select case(cmd)
       case("stddev")
          stddev = sqrt(stat_object(0.0, "variance"))
       case("variance")
          m = stat_object(0.0, "mean")
          if ( num > 0 ) then
             stddev = summa2/real(num) - m*m
          else
             stddev = 0.0
          end if
       case("count")
          stddev = real(num)
       case("mean")
          if ( num > 0 ) then
             stddev = summa/real(num)
          else
             stddev = 0.0
          end if
       case("reset")
          summa = 0.0
          summa2 = 0.0
          num = 0
       case default
          stddev = 0.0
       end select
    end if

  end function stat_object

end program Test_Stddev
