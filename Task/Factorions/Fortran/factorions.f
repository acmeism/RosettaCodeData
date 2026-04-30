! Factorions
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
program Factorions
integer, parameter :: minBase=9, maxBase = 12 ! minumum and maximum base used in this little program
integer, parameter :: factLim=1499999         ! Maximum factorial Number for all bases that are  used here
integer, dimension(0:maxBase-1) :: fact       ! Stored factorials for numbers 0...12

integer :: ii, jj, base

! Prepare cached factorial function
fact = 1
do ii=1, maxBase-1
  do jj= 2, ii
    fact(ii) = fact(ii) * jj
  enddo
end do

!
! Brute force: for all bases, for all numbers 1...max tes each number and print if its a factorion.
!
do base=minBase, maxBase
  write (*, '("The factorions in base ", i0, " are:")') base
  do ii=1, factLim
    if (isFactorion (ii, base)) write (*, '(1x,i0)', advance='no') ii
  enddo
  write (*,'(/)')
end do

contains

!
! Separate digits d of number n in base b, sum up d!, and compare result with n.
!
function isFactorion (n,b) result (YN)
integer, intent (in) :: n, b
logical :: YN
integer :: dig, nn, facts_sum

nn = N
facts_sum = 0
do while (nn .ne. 0)
  dig = mod (nn, b)
  nn = nn / b

  facts_sum = facts_sum + fact(dig)
enddo
yn = facts_sum .eq. n

end function isFactorion
end program Factorions
