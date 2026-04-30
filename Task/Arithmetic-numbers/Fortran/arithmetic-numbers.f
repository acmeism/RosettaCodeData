!
! Arithmetic numbers
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! No Non-standard features used, should compile on any fairly recent Fortran.
! straight copy of the algorithm presented in the C solution
! U.B., September 2025

program ArithmeticNumbers

implicit none

integer :: arithmetic_count=0, composite_count = 0
integer :: divisor_count, divisor_sum

integer  :: n=0

  do while (arithmetic_count .le. 1000000)
    n = n + 1
    call divisor_count_and_sum (n)

    if (mod (divisor_sum, divisor_count)  .ne. 0) then
            cycle
    end if

    arithmetic_count = arithmetic_count + 1;
    if (divisor_count .gt. 2)  &
      composite_count = composite_count + 1
    if (arithmetic_count .le. 100) then
      write (*, '(I3,X)', advance='no')   n
      if (mod (arithmetic_count, 10)  .eq. 0) &
        write (*,*)
    end if
    if (arithmetic_count .eq. 1000 .or. arithmetic_count .eq. 10000 .or. &
        arithmetic_count .eq. 100000 .or. arithmetic_count .eq. 1000000)  then

        write (*,'(/i0, "th arithmetic number is ", I0 )')  arithmetic_count, n
        write (*,'("Number of composite arithmetic numbers <= ", i0, ": ", i0)' )  &
          n,   composite_count
     endif
    end do

contains


subroutine  divisor_count_and_sum (arg_n)

    integer, intent(in)     :: arg_n
    integer :: n
    integer ::  power
    integer :: p, count, sum

    n = arg_n           ! need to modify n.
    divisor_count = 1
    divisor_sum = 1
    power = 2

    do while (iand (n,1) .eq. 0)
      divisor_count = divisor_count + 1
      divisor_sum = divisor_sum + power
      power = power * 2
      n = n / 2
    end do

    p = 3
    do while (p*p .le. n)
      count = 1
      sum = 1
      power = p
      do while (mod(n,p) .eq. 0)
        count = count + 1
        sum = sum + power
        power = power * p
        n = n / p
      end do
      divisor_count = divisor_count*count
      divisor_sum = divisor_sum *sum
      p = p + 2
    end do

    if (n .gt. 1)  then
        divisor_count = divisor_count * 2
        divisor_sum = divisor_sum * (n + 1)
    end if
end subroutine divisor_count_and_sum

end program
