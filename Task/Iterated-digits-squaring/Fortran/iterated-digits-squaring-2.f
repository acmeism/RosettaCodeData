!
!Iterated digits squaring, the efficient way.
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., April 2026
!

program IteratingDigitSquaring_Fast
implicit none
integer, parameter :: tInt =8

!array bounds is sort of random here, it's big enough for 64bit integers.
integer (kind=tInt), dimension (0:32*81) :: sums
integer :: n, i, j, s

integer (kind=tInt) :: count89

sums = 0
sums (0) = 1
n = 1
do
  do i=n*81,1,-1
    do j=1,9
      s=j*j
      if (s .gt. i) exit
      sums(i) = sums(i) + sums(i-s)
    enddo
  enddo


  count89 = 0

  do i=1,n*81
    if (.not. is89 (i)) cycle
    if (sums(i) +count89 .lt. 0) then
      write  (*, '("Counter overflow for 10^", i0)') n
      stop
    endif

    count89 = count89 + sums(i)
  enddo
  write (*, '("1->10^", i0, ": ", i0)')  n, count89
  n = n + 1
enddo

contains


function is89 (n) result (Yes89)
integer, intent(in) :: n
logical :: Yes89
integer :: nn, dig, s

nn = n
do
  s = 0
  do while (nn .ne. 0)
    dig = mod (nn, 10)
    s = s + dig*dig
    nn=nn/10
  enddo

  if (s .eq. 89) then
    Yes89 = .true.
    return
  else if (s .eq. 1) then
    Yes89 = .false.
    return
  endif
  nn = s
enddo

end function is89



end program IteratingDigitSquaring_Fast
