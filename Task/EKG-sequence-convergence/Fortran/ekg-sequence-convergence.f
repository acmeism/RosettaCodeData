  ! EKG sequence convergence
  ! tested with Intel ifx (IFX) 2025.2.0 20250605             on Kubuntu 25.04
  !             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
  !             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
  ! Note that VMS requires switch $Fortran/ccdefault=LIST
  ! otherwise 1st character of each output line is interpreted as
  ! Carriage Control character.
  !
module EKG
implicit none

integer, parameter :: nElementsToPrint=10


contains

subroutine ekgSequence (secondElm, nElm, isq)
  !
  ! Construct first 'nElm' elements of the EKG Sequence that has 'secondElm'
  ! as second element, knowing first element ios always 1.
  !

  integer, intent(in)   :: secondElm
  integer, intent(in)   :: nElm

  integer, intent(out)  :: isq (*)

  integer               :: candidate=2
  integer               ::  ncurrent

  isq(1) = 1            ! 1st element always 1
  isq(2) = secondElm    ! 2nd element from argument
  ncurrent = 2          ! index to highest known element of sequence isq

  do while (ncurrent .le. nElm)
    ! 'candidate' is next element of isq if it is not already in this sequence AND
    ! if it shares at least 1 prime factor with highest known element if isq
    ! which means GCD(candidate, highest element of isq) is >1
		if ( (.not. containsElement (isq, ncurrent,  candidate))  &
         .and.  gcd(isq(ncurrent), candidate) > 1 )  then
      ! found next element of isq
			ncurrent = ncurrent + 1
      isq(ncurrent) = candidate
			candidate = 2;      ! start over again
		else
      ! Not a candidate: try next one.
			candidate= candidate + 1
		end if
  end do
end subroutine ekgSequence

function containsElement (isq, nElm, elm) result (yes)
  !
  ! return .true. if number 'elm' can be found within
  ! first 'nElm' elements of sequence 'isq' .
  !
  integer, intent(in) :: nElm
  integer, intent(in) :: isq (nElm)
  integer, intent(in) :: elm
  logical             :: yes
  integer             :: ii

  ! Straightforward: Loop until elm found or
  ! last element reached
  do ii = 1, nElm
    if (isq(ii) == elm) then
      yes=.true.
      return
    end if
  end do
  yes=.false.
  return
end function containsElement


function gcd (n,m) result (rgcd)
  !
  ! euclid's algorithm
  ! to find greatest common divisor
  !
  integer, intent(in) :: n,m
  integer             :: rgcd
  integer             :: a
  integer             :: b

  a=n
  b=m

  if (a .eq. 0) then
    rgcd = 0
  else
    do while (b .ne. 0)
      if ( a .gt. b )   then
        a = a - b
      else
        b = b - a;
      end if
    end do
    rgcd =a
  end if
end function gcd


subroutine printThem (isq)
!
! Print the pedefined number of elements of sequence isq
!
integer, intent(in) :: isq(nElementsToPrint)
integer             :: ii

! print the Introduction like EKG(2) and first elemment
write (6, '("EKG(", I2,") = [", i1,x)', advance='no') isq(2), isq(1)

! print remaining elements except the last
do ii = 2, nElementsToPrint-1
  write (6,'(i2, x)', advance  = 'no' ) isq(ii)
end do

! Terminate output line: last element and  close "]"
write (6,'(I2, "]")')   isq(nElementsToPrint)

end subroutine printThem

end module EKG


program EKGMain

  use EKG

  implicit none

  integer :: myekg(100)
  integer :: ekg5 (100)
  integer :: ekg7 (100)
  integer :: nx(5) = [2,5,7,9,10]
  integer :: match
  integer:: ii, jj
  !
  ! Produce and print first 10 elements of first 5 sequences
  !
  do ii=1,5
     call ekgSequence (nx(ii), nElementsToPrint, myekg)
     call printThem (myekg)
  end do
  !
  ! Produce 100 elements of EKG(5) and EKG(7)
  !
  call ekgSequence (5, 100, ekg5)
  call ekgSequence (7, 100, ekg7)
  !
  ! see where they converge
  !
  match = -1
  do ii=2, 100
    if (ekg5(ii) .eq. ekg7(ii)) then
      ! Memoize first identical elements and
      ! see if all following elements are identical as well.
      if (match .lt. 0) match = ii
      do jj=ii+1,100
        if (ekg5(jj) .ne. ekg7(jj)) then
          match = -1    ! Not same
        endif
      end do
    end if
  end do
  write (6, "( /'EKG(5) and EKG(7) converge at index ', i0, '.')")  match
end program EKGMain
