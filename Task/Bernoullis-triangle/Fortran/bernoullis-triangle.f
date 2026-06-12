!
! Bernoulli's triangle
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! No Non-standard features used, should compile on any fairly recent Fortran.
! U.B., January 2026
!==============================================================================

program BernoulliTriangle
implicit none

integer, parameter :: nRows=15, nCols=nRows

! We do not need entire triangle, only bottom 2 rows
integer :: row (nCols, 2)               ! Current and previous row
integer :: r, c                         ! Row, Column  as loop index
integer ::  cur=1, prv=2                ! Point to current and previous row

do r=1, nRows
  ! Prepare ptr which row is new current, which is previous
  cur = prv                 ! new current
  prv = 3 - cur             ! now "the other row", 2->1, 1->2

  row (1, cur) = 1          ! col 1 of each row is constant 1.

  ! Fill the other cols except the last in this row
  do c=2, r-1               ! Fill columns of current row
    row (c, cur) = row (c-1,prv) + row(c,prv)
  end do

  ! Finish last col is 2^row:
  row (r,cur) = 2**(r-1)     ! last col of each row is always 2^row

  ! Print resultant current row
  do c=1, r
    write (*, '(i0,x)', advance='no') row (c,cur)
  end do
  write (*,*)   ! end line
end do

end program BernoulliTriangle
