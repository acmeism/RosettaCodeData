! Fivenum
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! Uses non-standard intrinsic isnan(), available as extension on all 3 mentioned compilers
! U.B., January 2026
!=========================================================================================

program p_fivenum

implicit none
integer, parameter :: dp=8

real (kind=dp), dimension(11)  :: x1 = [15.0, 6.0, 42.0, 41.0, 7.0, 36.0, 49.0, 40.0, 39.0, 47.0, 43.0]
real (kind=dp), dimension(6)   :: x2 = [36.0, 40.0, 7.0, 39.0, 41.0, 15.0]

! With so many valid digits, its better to specify the constants as real (kind=dp) to avoid precision loss
real (kind=dp), dimension(20)  :: x3 = [0.14082834_dp, 0.09748790_dp,  1.73131507_dp,  0.87636009_dp, -1.95059594_dp,  &
                                       0.73438555_dp, -0.03035726_dp,  1.46675970_dp, -0.74621349_dp, -0.72588772_dp,  &
                                       0.63905160_dp,  0.61501527_dp, -0.98983780_dp, -1.00447874_dp, -0.62759469_dp,  &
                                       0.66206163_dp,  1.04312009_dp, -0.10305385_dp,  0.75775634_dp,  0.32566578_dp]
real (kind=dp), dimension(5) :: result

if (fivenum (x1,result,size(x1))) call show (result, '(5 (X,F4.1))')
if (fivenum (x2,result,size(x2))) call show (result, '(5 (X,F4.1))')
if (fivenum (x3,result,size(x3))) call show (result, '(5 (X,F11.8))')

contains

function fivenum (x,res,n) result(OK)

integer,intent(in) :: n                                   ! size of the...
real (kind=dp), dimension(n), intent (inout) :: x         ! value array
real (kind=dp), dimension(5), intent(out) :: res          ! the 5-number result
logical :: OK                                             ! this will signal success or failure

integer :: ii                                             ! loop index
integer:: rmid, lmid                                      ! index to the 2 central elements of the array
                                                          ! ... these values are different if n is even

!-- Check for invalid input: nan is not a number to calculate with
OK = .true.                     ! Assume success
do ii=1,n
  if (isnan (x(ii))) then       ! isNan() is non-standard extension in IFX and also in gfortran
    OK = .false.                ! signal fault
    print *, 'Unable to deal with arrays containing NaN'
    return
  endif
end do

! value array must be sorted ascending
call quicksort_real (x, 1, n)

! Divide array into 4 sections
rmid = 1 + n/2                                            ! right middle
if (mod (n, 2) .eq. 1) then                               ! odd array size?
  lmid = rmid                                             ! left and right half end/begin on the same element
else
  lmid = rmid - 1                                         ! left half ends at lmid, right half begins at rmid.
end if

! fill result values as defined
res(1) = x(1)                                             ! min value
res(2) = median (x, 1, lmid)                              ! lower hinge
res(3) = median (x,1,n)                                   ! Median of all
res(4) = median (x,rmid,n)                                ! upper hinge
res(5) = x(n)                                             ! max value
end function fivenum

!==================
! Print the result
!==================
subroutine show (r,form )

real(kind=dp),dimension(5), intent(in) ::r
character (len=*), intent(in)   :: form

write (*,form)  r
end subroutine show

! ==============================================================================
! Calculate median of all elements of array x() between index ip1 and ip2 (incl)
! ==============================================================================
function median (x, ip1, ip2) result (med)

real (kind=dp), dimension(:), intent(in) :: x         ! the entire array
integer, intent(in) :: ip1, ip2                       ! end points of the part we need the median
real (kind=dp) :: med                                 ! the calculated median

integer :: numberOfElements, midIndex                 ! size of the slice, index to middle of hte slice

numberOfElements = 1 + ip2-ip1
midIndex = ip1 + numberOfElements/2

if (mod (numberOfElements,2) .eq. 1) then             ! Odd number of elements: take middle value
  med = X(midIndex)
else                                                  ! Even number of values: average of 2 central values
  med = (X(midIndex-1) + x(midIndex) ) / 2.
endif

end function median

! =========================
! sort array of real values
! =========================
recursive subroutine quicksort_real (arr, low, high)

real (kind=dp), dimension(:), intent(inout) :: arr
integer, intent(in) :: low, high
integer :: pivot_index
integer :: i, j, mid
real (kind=dp) :: pivot, temp

if (low .lt. high) then
  ! Assume the list is already "almost sorted", so use middle word as pivot.
  mid = low + (high-low) / 2
  pivot = arr(mid)
  !Move pivot to the end
  temp = arr(mid)
  arr(mid) = arr(high)
  arr(high)=temp
  i = low - 1

  do j = low, high - 1
    if (arr(j) .le. pivot) then
      i = i + 1
      temp = arr(i)
      arr(i) = arr(j)
      arr(j) = temp
    end if
  end do

  temp = arr(i+1)
  arr(i+1) = arr(high)
  arr(high) = temp
  pivot_index = i + 1

  call quicksort_real (arr, low, pivot_index - 1)
  call quicksort_real (arr, pivot_index + 1, high)
end if
end subroutine quicksort_real


end program p_fivenum
