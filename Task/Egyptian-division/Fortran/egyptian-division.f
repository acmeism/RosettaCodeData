  ! Egyptian Division Algorithm
  ! tested with Intel ifx (IFX) 2025.2.0 20250605             on Kubuntu 25.04
  !             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
  !             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3

  module EgyptionDiv
  implicit none

  integer, parameter    :: mxPow=64             ! maximum table size when using 8-byte integers.
  integer(Kind=8)       :: powers (mxPow)
  integer(Kind=8)       :: doubles (mxPow)
  integer(kind=8)       :: accumulator, accsum

  contains

  function  eDivide (dividend, divisor, remainder)  result(answer)

    integer(kind=8), intent(in)  :: dividend, divisor
    integer(kind=8), intent(out) :: remainder
    integer(kind=8)              :: answer


    integer :: ii, iMax

    ! setup initial table with powers of 2 and doubles if divisor
    ! this is step 1...4 from algorithm description page.
    powers(1) = 1
    doubles(1) = divisor
    do ii=2, mxPow
      powers(ii) = powers(ii-1) * 2
      doubles(ii) = doubles(ii-1) * 2
      if (doubles(ii) .gt. dividend)   EXIT    ! enough done.
      iMax = ii
    end do

    ! walk through this table in reverse order, starting at previus max value
    ! this are steps 5...8 of algorithm description page.
    answer =0
    accumulator = 0

    do ii=imax,1,-1
      accsum = accumulator + doubles (ii)
      if (accsum .le. dividend) then
        accumulator = accsum
        answer = answer + powers (ii)
      end if
      if (ii .eq. 1) then
        remainder = abs (dividend - accumulator)
      end if
    end do

  end function eDivide
end module EgyptionDiv


program EDivMain
  ! try above module EgyptionDiv as requested in the description
  use EgyptionDiv

  integer (kind=8) divisor, dividend, result, remainder

  dividend = 580
  divisor  = 34
  result = eDivide (dividend, divisor, remainder)

  print ("(i0, ' divided by ', i0, ' using the Egyption method is ', i0,  ' remainder ', i0)"), &
         dividend,divisor, result,remainder

end program EDivMain
