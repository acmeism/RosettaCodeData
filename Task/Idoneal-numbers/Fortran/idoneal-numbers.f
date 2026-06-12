!
! Idoneal numbers
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., May 2026
!
program Idoneal
implicit none
integer, parameter :: nMax=65    ! Number of known Idoneal Numbers
integer :: cnt, i

i = 0
cnt = 0
do while (cnt .lt. nMax)
  i = i + 1
  if (isIdoneal (i)) then
    cnt = cnt + 1
    write (*, '(i5)', advance='no') i
    if ( mod (cnt, 13) .eq. 0) then   ! Print 13 in a row, makes 5 rows to print 65 numbers
      write (*,*)
    endif
  endif
end do

contains

function isIdoneal (n) result (YN)
integer, intent(in) :: n
logical :: YN

integer :: i,j,k, sum

YN = .true.
do i=1, n-3
  do j=i+1,n-2
    if (i*j +i+j .gt. n) exit
    do k = j+1,n-1
      sum = i*j + j*k + i*k
      if (sum .eq. n) then
        YN = .false.
        return
      else if (sum .gt. n) then
        exit
      endif
    enddo
  enddo
enddo

end function isIdoneal
end program Idoneal
