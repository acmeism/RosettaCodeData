! Experimental Verification of the NKTg Law Using NASA Mercury Data in 2025
!
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., March 2026
!
program NKTG_Mercury
implicit none
integer, parameter :: DP=8

! Orbital and mass data from Table 3:
real (kind=DP), dimension(5) :: x =[5.16E10,6.97E10,5.49E10,6.83E10,4.61E10], &
   v = [5.34E4,3.89E4,5.04E4,3.98E4,5.89E4], &
   m = [3.3E23,3.3E23,3.3E23,3.3E23,3.3E23]

character (len=10), dimension(5) :: date = ["01/01/2025","01/04/2025","01/07/2025","01/10/2025","31/12/2025"]

real (kind=DP) :: NKTg1_ref , xRef = 4.64E10, vRef=5.81E4, mRef=3.3E23     ! The reference values of 31/12/2024
real (kind=DP),parameter :: dm_dt = -0.5                                   ! Assumed mass loss
real (kind=DP)  :: NKTg2Res, vRes, mRes, pRes, RelError_v                  ! Result values


integer :: ii                                                              ! Loop index

! Remember: the cross product of the planet's position vector and the momentum vector is the angular momentum
! xRef is close to the  minor axis of mercury's elliptical orbit, so the angle between x and p is nearly 90°
! and its sine is close to 1. This means "NKTg1_ref" is about the absolute value of the angular momentum and,
! as such, it is conserved.
!
NKTg1_ref  = xRef*mRef*vRef


write (*,'("NKTg1 reference constant:",X, 1PD10.3,/ &
& ,"====================================",/)')   NKTg1_ref

write (*,'("Date           v_NKTg       v_NASA     Rel.Error(%)   NKTg2",/  &
& "---------------------------------------------------------------")')
do ii=1, 5
  vRes = NKTg1_ref  / (x(ii)*m(ii))
  pRes = m(ii) * vRes
  NKTg2Res = dm_dt * pRes
  RelError_v =  (vRes-v(ii)) / v(ii) * 100
  write (*,'(A10,4x,2(1PD10.3,3x), 0pF8.5, 5x,1pD10.3)')   date(ii),  vRes, v(ii), RelError_v, NKTg2Res
end do

write (*,'(/,"========================================", / &
& , "Interpretation:",/, &
& "NKTg1 maintained as constant. This makes sense because NKTg1 is basically the angular momentum", / &
& "NKTg2 negative -> no effekt. A planet in orbit loses 0.5 kg/s of its mass, that is close to nothing." )')

end program NKTG_Mercury
