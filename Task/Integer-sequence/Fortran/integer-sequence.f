program Intseq
  implicit none

  integer, parameter :: i64 = selected_int_kind(18)
  integer(i64) :: n = 1

! n is declared as a 64 bit signed integer so the program will display up to
! 9223372036854775807 before overflowing to -9223372036854775808
  do
    print*, n
    n = n + 1
  end do
end program
