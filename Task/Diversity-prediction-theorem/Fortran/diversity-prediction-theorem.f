! Diversity prediction theorem
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
program DivTheo

implicit none
integer, parameter :: DP = 8    ! Kind for double precision Reals

real (kind=DP), dimension(3), parameter  ::  Case1 =[48._DP,47._DP,51._DP]
real (kind=DP), dimension(4), parameter  ::  Case2 =[48._DP,47._DP,51._DP,42._DP]


call diversityTheorem (49._DP, case1, size(Case1))
write (*,*)
call diversityTheorem (49._DP, case2, size(Case2))

contains
subroutine diversityTheorem (trueValue, predictions, n)
real (kind=DP), intent(in) :: trueValue
integer, intent(in) :: n
integer :: i
real (kind=DP), dimension(n), intent(in) :: predictions

real (kind=DP) :: avPred

avPred = sum(predictions,n) / n
! From the task desciption:
! show...
!   the true value   and   the crowd estimates
!   the average error
!   the crowd error
!   the prediction diversity
write (*, '("true value       :", F4.0)')  trueValue
write (*, '("crowd''s estimate :", 8F4.0)') (predictions(i),i=1,n)
write (*, '("average error    :", F8.4 )') avSqDiff (trueValue, predictions, n)
write (*, '("crowd error      :", F8.4 )') (trueValue - avPred) ** 2
write (*, '("diversity        :", F8.4 )') avSqDiff (avPred, predictions, n)
end subroutine diversityTheorem



function avSqDiff (av, pred, n) result (sqDiff)

integer, intent(in) :: n
real (kind=DP), intent(in)  :: av
real (kind=DP), dimension(n), intent(in) :: pred
real (kind=DP) sqDiff
integer :: ii
sqDiff = 0
do ii=1,n
  sqdiff = sqdiff + (av-pred(ii))**2
enddo
sqDiff = sqDiff / n

end function avSqDiff

end program DivTheo
