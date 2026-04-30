!
! Longest increasing subsequence
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! No Non-standard features used, should compile on any fairly recent Fortran.
! U.B., January 2026
!==============================================================================

program LIS
implicit none

! The two sequences of the task description
!
integer, parameter, dimension( 6) :: S1=[3,2,6,4,5,1]
integer, parameter, dimension(16) :: S2=[0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15]
! dimension(*) is not used only to make VSI Fortran (on openVMS) happy.
! Intel and GNU Fortran work with dimension(*)

! Find and print the Longest Increasing Subsequences
call printLIS (S1, size(S1))
call printLIS (S2, size(S2))

contains

! ====================================================================
! Find and print the longest increasing subsequence (LIS) of array X.
! Algorithm as well as Notation as described in the wikipedia article
! https://en.wikipedia.org/wiki/Longest_increasing_subsequence
! ====================================================================
subroutine printLIS (X, LS)

integer, intent(in) :: LS
integer, intent(in), dimension(LS)   :: X

integer, dimension(LS) :: result      ! found longest increasing subsequence
integer, dimension(LS) :: P           ! list of Predecessors
integer, dimension(LS) :: M           ! Note this does not need to be longer because we're 1-based.

integer :: L                          ! Current length of LIS
integer :: newl                       ! New estimate of LIS length
integer :: i                          ! Loop index
integer :: lo, hi, mid                ! helpers for binary search
integer :: k                          ! index for for the chain od the LIS

L=0
do i=1,LS
  ! Binary search for the smallest positive l ≤ LS
  ! such that X[M[l]] >= X[i]  lo=1
  lo = 1
  hi = L
  do while (lo .le. hi)                 ! Note on very first time, lo is1 and l is 0 ...
    mid = (lo+hi) / 2
    if (X (M(mid)) .lt. X(i))  then     ! ... hence no problem with uninitialized M
      lo = mid+1
    else
      hi=mid-1
    endif
  end do
  ! After this search, lo is 1 greater than the
  ! length of the longest prefix of X(i)
  newL = lo
  ! The predecessor of X[i] is the last index of
  ! the subsequence of length newL-1
  P(i) = M(newL-1)
  M(newl) = i
  if (newl .gt. L) then
    ! If we found a subsequence longer than any we've
    ! found yet, update L
    L = newL
  endif
enddo

! Reconstruct the longest increasing subsequence
! It consists of the values of X at the L indices:
! ...,  P[P[M[L]]], P[M[L]], M[L]
k = M(L)                  ! This is the last element,
do i = L, 1, -1           ! now go dotn to the first.
  result(i) = X(k)
  k = P(k)
end do

! Print in increasing order
write (*,'(10(I0,x))') (result(i),i=1,L)

end subroutine printLIS
end program LIS
