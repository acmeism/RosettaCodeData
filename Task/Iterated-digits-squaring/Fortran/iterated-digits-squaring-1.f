!
! Iterated digits squaring
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., April 2026
!

program IteratingDigitSquaring

integer, dimension (100000000) :: known       ! Storage for intermediate results
integer :: ii, count                          ! Loop index, and counter for sequences ending at 89

! Initialise
count = 0
known=0

! Try all integers in range, and count when their iteration chain ends with 89.
do ii=1, 100000000
  if (ends89 (ii)) count=count+1
enddo

write (*, '(I0)')    count
contains


! ======================================
! Return next element in iteration chain
! ======================================
function nextInChain (n) result (nxt)
integer, intent(in) :: n
integer :: nxt

integer :: nn, dig

! If successor of n has already been calculated, return already known value
if (known (n) .ne. 0) then
  nxt = known(n)
else
! successor of n has not yet been calculated. Do it now, and remember the result for next time
  nxt = 0
  nn = n
  do while (nn .ne. 0)        ! As long as 0 not yet reached:
    dig = mod (nn, 10)        ! Extract last digit
    nxt = nxt + dig*dig       ! Square and add to total result
    nn = nn / 10              ! go get next least digit
  end do
  known(n) = nxt              ! store result
endif
end function nextInChain

! ================================================
! See if the sequence starting at 'n' ends with 89
! ================================================
function ends89 (n) result (Yes89)
integer, intent(in) :: n
logical :: Yes89
integer :: nn

! Starting with n, and go through the entire sequence to its end
nn = n
do while (nn .ne. 1 .and. nn .ne. 89)
  nn = nextInChain (nn)
enddo
! The sequence either ends at 89, or at 1.
Yes89 = nn .eq. 89
end function ends89

end program IteratingDigitSquaring
