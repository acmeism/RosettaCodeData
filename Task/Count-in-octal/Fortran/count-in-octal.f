program Octal
  implicit none

  integer, parameter :: i64 = selected_int_kind(18)
  integer(i64) :: n = 0

! Will stop when n overflows from
! 9223372036854775807 to -92233720368547758078 (1000000000000000000000 octal)
  do while(n >= 0)
    write(*, "(o0)") n
    n = n + 1
  end do
end program
