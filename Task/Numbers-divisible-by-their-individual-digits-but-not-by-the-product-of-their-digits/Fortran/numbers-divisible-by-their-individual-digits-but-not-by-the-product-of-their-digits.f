! Numbers divisible by their individual digits, but not by the product of their digits
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS x86_64 V9.2-3
!
program DivisibleDig

implicit none
integer, parameter :: nMax=1000, nLine=10
integer :: n, count

count = 0
do n=1,nMax
  if (isDiviDig (n)) then                   ! n is divisible by its digits but not by product of its digits
    write (*, '(I4)', advance='no')   n     ! print it
    count = count + 1                       ! but only maximum nLine(=10) in one line
    if (count .eq. nLine) then              ! otherwise
      write (*,*)                           ! terminate current line
      count=0                               ! and start counting again.
    endif
  endif
enddo
if (count .ne. 0) write (*,*)               ! Terminate last line if not yet done

contains

! =============================================================================================
! return true if the argument n is divisible by its digits but not by the product of its digits
! =============================================================================================
pure function isDiviDig (arg_n) result (ItIs)
integer, intent(in) :: arg_n
logical :: ItIs

integer :: n, dig, prod                     ! copy of argument n, one digit, product of digits

prod=1
n = arg_n

do while (n .gt. 0)
  dig = mod (n,10)
  if (dig .eq. 0) then                        ! digit is 0, sop it does not divide n
    ItIs = .false.
    return
  else if (mod (arg_n,dig) .ne. 0) then       ! digit is not 0, but it does not divide n
    ItIs = .false.
    return
  endif
  prod = prod * dig
  n = n / 10
enddo

ItIs = (mod(arg_n, prod) .ne. 0)

end function isDiviDig

end program DivisibleDig

