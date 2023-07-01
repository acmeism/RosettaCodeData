program r2cf_demo
  implicit none

  call write_r2cf (1, 2)
  call write_r2cf (3, 1)
  call write_r2cf (23, 8)
  call write_r2cf (13, 11)
  call write_r2cf (22, 7)
  call write_r2cf (-151, 77)

  call write_r2cf (14142, 10000)
  call write_r2cf (141421, 100000)
  call write_r2cf (1414214, 1000000)
  call write_r2cf (14142136, 10000000)

  call write_r2cf (31, 10)
  call write_r2cf (314, 100)
  call write_r2cf (3142, 1000)
  call write_r2cf (31428, 10000)
  call write_r2cf (314285, 100000)
  call write_r2cf (3142857, 1000000)
  call write_r2cf (31428571, 10000000)
  call write_r2cf (314285714, 100000000)

contains

  ! This implementation of r2cf both modifies its arguments and
  ! returns a value.
  function r2cf (N1, N2) result (q)
    integer, intent(inout) :: N1, N2
    integer :: q

    integer r

    ! We will use floor division, where the quotient is rounded
    ! towards negative infinity. Whenever the divisor is positive,
    ! this type of division gives a non-negative remainder.
    r = modulo (N1, N2)
    q = (N1 - r) / N2

    N1 = N2
    N2 = r
  end function r2cf

  subroutine write_r2cf (N1, N2)
    integer, intent(in) :: N1, N2

    integer :: digit, M1, M2
    character(len = :), allocatable :: sep

    write (*, '(I0, "/", I0, " => ")', advance = "no") N1, N2

    M1 = N1
    M2 = N2
    sep = "["
    do while (M2 /= 0)
       digit = r2cf (M1, M2)
       write (*, '(A, I0)', advance = "no") sep, digit
       if (sep == "[") then
          sep = "; "
       else
          sep = ", "
       end if
    end do
    write (*, '("]")', advance = "yes")
  end subroutine write_r2cf

end program r2cf_demo
