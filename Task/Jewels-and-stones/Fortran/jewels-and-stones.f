! Jewels and Stones
! tested with Intel ifx (IFX) 2025.2.0 20250605             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! July 2025
!
! THis solution contains 2 functions: JewelCount and fastJewelCount.
! The first function tries to find each letter of Jewels in Stones
! The second uses a character map built from the letters of Jewels, then
! iterates through letters of Stones, looking up these in the map and
!
!----------------------------------------------------------------------------
!
! Return the number of Jewels that can be found in Stones.
!
function JewelCount (stones, jewels) result (NumberOfJewels)

implicit none

character(len=*), intent(in)  :: stones, jewels       ! Function arguments
integer                       :: NumberOfJewels       ! Return value
integer                       :: ii, jj               ! Loop indices
NumberOfJewels = 0

! We go through both input strings using a nested loop
! so it runs in O(len(jewels) * len(stones))
! Is certainly good enough for short input strings.
! See below for faster version.
!
do jj=1, len (stones)
  do ii=1, len (jewels)
    if (stones(jj:jj) .eq. jewels(ii:ii)) then
      NumberOfJewels = NumberOfJewels + 1
      EXIT          ! letters in "jewels" are unique. Dont proceed.
    end if
  end do
end do

end function JewelCount       ! ======================================

!
! This function does the same as above function JewelCount.
! It might be faster for very long input "stones".
! It First creates a map of all letters in "jewels", then
! it adds one for each letter of "stones" found therein.
! works in O(len(jewels) + len(stones))
!
function fasterJewelCount (stones, jewels) result (NumberOfJewels)
implicit none
integer, parameter            :: maxChar=128          ! sufficient for A-Z,a-z
character(len=*), intent(in)  :: stones, jewels       ! Function arguments
integer                       :: NumberOfJewels       ! Return value
integer                       :: ii                   ! Loop index
integer                       :: ic
integer                       :: jMap(maxChar) = 0

NumberOfJewels = 0

! Insert letter of "jewels" into the map
do ii=1, len (jewels)
  ic = ichar (jewels(ii:ii))
  if (ic >=1 .and. ic <= maxChar) then    ! never trust correctness of input
    jMap(ic) = 1                          ! Assuming all letters of "jewels" appear only once
  end if
end do

! add one for each letter of "jewels" that can be found in the map
do ii=1, len (stones)
  ic = ichar (stones(ii:ii))
  if (ic >=1 .and. ic <= maxChar) then    ! better safe than sorry
    NumberOfJewels = NumberOfJewels + jMap(ic)
  end if
end do

end function fasterJewelCount

!
! A little main program demonstrates usage of functions JewelCount and fastJewelCOunt
!
program progCountJewels

implicit none
integer, external   :: JewelCount, fasterJewelCount

print *, JewelCount ('aAAbbbb', 'aA')           ! expect 3
print *, JewelCount ('ZZ', 'az')                ! expect 0
print *, fasterJewelCount ('aAAbbbb', 'aA')     ! expect 3
print *, fasterJewelCount ('ZZ', 'az')          ! expect 0

end program progCountJewels
