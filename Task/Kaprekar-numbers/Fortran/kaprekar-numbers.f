program Karpekar_Numbers
  implicit none

  integer, parameter :: i64 = selected_int_kind(18)
  integer :: count

  call karpekar(10000_i64, .true.)
  write(*,*)
  call karpekar(1000000_i64, .false.)

contains

subroutine karpekar(n, printnums)

  integer(i64), intent(in) :: n
  logical, intent(in) :: printnums
  integer(i64) :: c, i, j, n1, n2
  character(19) :: str, s1, s2

  c = 0
  do i = 1, n
    write(str, "(i0)") i*i
    do j = 0, len_trim(str)-1
      s1 = str(1:j)
      s2 = str(j+1:len_trim(str))
      read(s1, "(i19)") n1
      read(s2, "(i19)") n2
      if(n2 == 0) cycle
      if(n1 + n2 == i) then
        c = c + 1
        if (printnums .eqv. .true.) write(*, "(i0)") i
        exit
      end if
    end do
  end do
  if (printnums .eqv. .false.) write(*, "(i0)") c
end subroutine
end program
