program test_gosper
use iso_fortran_env,only: i4=>int32
  implicit none

  ! Test starting values
  call test_initial(1)
  call test_initial(3)
  call test_initial(7)
  call test_initial(15)

contains

  !-------------------------------------------------------
  ! Subroutine to apply 'next' ten times to an initial value
  ! and print each result.
  !-------------------------------------------------------
  subroutine test_initial(initial)
    implicit none
    integer(i4), intent(in) :: initial
    integer(i4) :: current
    integer :: iter

    current = initial
    print *, "Initial value: ", current
    do iter = 1, 10
       current = next(current)
       print *, "  Iteration", iter, "=>", current
    end do
    print *, "---------------------------"
  end subroutine test_initial

  !-------------------------------------------------------
  ! Pure function next: returns the next higher integer
  ! with the same number of set bits as n, using Gosper’s Hack.
  !-------------------------------------------------------
  pure function next(n) result(res)
    implicit none
    integer(i4), intent(in) :: n
    integer(i4) :: res
    integer(i4) :: a, b, c, t

    ! If n is 0, no bits are set; return 0.
    if (n == 0) then
       res = 0
       return
    endif

    ! Gosper's Hack:
    ! a: isolates the rightmost set bit using bitwise AND of n and its two's complement.
    a = iand(n, -n)
    ! b: adding a to n moves that bit to the next position.
    b = n + a
    ! c: XOR of n and b gives the bits that changed.
    c = ieor(n, b)
    ! t: right-shift the changed bits by 2 and then divide by a.
    t = (ishft(c, -2)) / a
    ! res: combine b with t using bitwise OR.
    res = ior(b, t)
  end function next

end program test_gosper
