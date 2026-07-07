! Mian-Chowla sequence
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 26.04
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 26.04
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., June 2026

program MianChowla
implicit none

integer, parameter :: kInt = 4
integer, parameter :: nSeq=100, nSum=(nseq*(nseq+1))/2    ! With n elements, there tar n*(n+1)/2 distinct pairs
integer(kind=kint), dimension(nSeq) :: theSequence
integer(kind=kint), dimension(nSum) :: sums

integer :: ii

theSequence (1) = 1
sums = 0

call fillSequence()

! Find and display, here, on this page the first 30 terms of the Mian–Chowla sequence.
write (*, '("The first 30 terms of the sequence are:")')
do ii=1, 30
  write (*, '(i6)', advance='no')    theSequence (ii)
  if (mod (ii, 10) .eq. 0) then
    write (*,*)
  endif
enddo

! Find and display, here, on this page the 91st through 100th terms of the Mian–Chowla sequence.
write (*, '(//,"The terms 91 to 100 of the sequence are:")')
do ii=91, nSeq
  write (*, '(i6)', advance='no')    theSequence (ii)
end do
write (*,*)

contains

! ===========================================================
! Calculate the first 'nSeq' terms of the Mian-Chwla sequence
! ===========================================================
subroutine fillSequence()
integer :: i, j, k, sum, lastSumLEngth, currentSumLEngth

theSequence (1) = 1
sums(1) = 2
currentSumLEngth = 1

! loop to calculate 'nSeq' first terms of tehe Mian-Chowla sequence
do i = 2, nSeq
	lastSumLEngth = currentSumLEngth                ! save current length os sums array
  j = theSequence (i-1)                           ! to be incremented at beginniing of following loop
	jLoop: do                                       ! Try next larger J's as possible i'th term of the sequence
    j = j + 1
		theSequence (i) = j
    ! See if this j can be used:
    ! All elements of the sequence so far should bew added to j, and the result must
    ! not be an already known sum of 2 terms
		do k = 1, i
			sum = theSequence (k) + j
			if (Contains(sums, sum, currentSumLength))  then
        ! This j cannot be used because it adds with sequence(k) to an already kniown sum
				currentSumLEngth = lastSumLEngth           ! Reset length of sums array to previously known value
        cycle jLoop                                ! Go and try next higher j
			endif
      ! So far it is promising. Store current sum and try with next known sequence element
  		sums(currentSumLEngth) = sum                 ! Append current sum to list of sums
      currentSumLEngth = currentSumLEngth + 1      ! and increment sums' size
		end do
    ! Here if j can be used as term # i in the sequence
		exit                                             ! Quit searching for usable j
	end do 	jLoop
enddo

end subroutine fillSequence

! ===================================================================
! Return true if item 'item' appears in list 'lst' witrh length 'siz'
! ===================================================================
function Contains(lst, item, siz)  result (YN)
integer, intent(in) :: item, siz
integer(kind=kint), dimension(siz), intent(in) :: lst
logical :: YN

integer :: i
! Iterate through lst, immediate return.true. if item found.
do i = 1,  siz
  if (item .eq. lst(i))  then
    YN = .true.
    return
  endif
end do
! Checked all elements without finding item.
YN = .false.      ! Not Contained
end function Contains


end program MianChowla
