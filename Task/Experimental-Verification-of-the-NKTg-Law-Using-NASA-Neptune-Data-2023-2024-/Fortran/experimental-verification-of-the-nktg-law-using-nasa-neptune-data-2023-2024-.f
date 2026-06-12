! Experimental Verification of the NKTg Law Using NASA Neptune Data (2023–2024)
!
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., March 2026
!
program NKTg_Neptune

implicit none
integer, parameter :: DP=8


! Given Neptune's orbital data from 2023:

character (len=10), dimension(5) :: date23 = ["01/01/2023","01/04/2023","01/07/2023","01/10/2023","31/12/2023"]
character (len=10), dimension(5) :: date24 = ["01/01/2024","01/04/2024","01/07/2024","01/10/2024","31/12/2024"]

! The x values are symmetric with center 1-Jul-2023. This is surprising, to say the least.
real(kind=DP), dimension(5) :: X23 =[4498396440.,4503443661.,4553946490.,4503443661.,4498396440. ], &
  v23=[5.43,5.43,5.43,5.43,5.43], &
  m23=[1.02430000D26, 1.02429980D26, 1.02429960D26, 1.02429940D26, 1.02429920D26], &
  dmdt23=[-0.00002000,-0.00002000,-0.00002000,-0.00002000,-0.00002000]       ! Serious? Mass loss is 0.00002 kg ?

real(kind=DP) :: mNasaReference =  1.02430D26, NKTg1(2), NKTg2(2), totalNKT(2)

! Be aware that Neptun takes about 165 years for 1 orbital circulation.
! The x and v values at 4 given points of time are precisely the same as in 2023: This is most
! certainly wrong.For the calculation here it is irreleveant. Only the overall quality suffers.
! (Garbage in-> Garbage out)
real(kind=DP), dimension(5) :: X24sim =[4498396440.,4503443661.,4553946490.,4503443661.,4498396440.], &
  v24sim=[5.43,5.43,5.43,5.43,5.43], &
  m24sim=[1.02429900D26, 1.02429880D26, 1.02429860D26, 1.02429840D26, 1.02429820D26], &
  dmdt224sim=[-0.00002000,-0.00002000,-0.00002000,-0.00002000,-0.00002000]

integer :: ii
! With the speed and velocity values being identical in 2024 and 2025, there is zero deviation,
! only for the mass there is something to calculate. Since the momentum and the NKTg values are
! proportional to the mass, the relative deviations can be expected to be the same as for the masses.
do ii=1, 5
  write (*, '(/"Date: ", T20, A, 9x,A)')              date23(ii), date24(ii)
  write (*, '("Position (x):", T18, 2(1PD15.7,4x))')  X23(ii), X24sim(ii)
  write (*, '("Velocity (v):", T18, 2(1PD15.7,4x))')  v23(ii), v24sim(ii)
  write (*, '("Mass :", T18, 2(1PD15.7,4x), " Mass deviation 2024: ", 1pD10.3,"%")')  m23(ii), m24sim(ii) , abs(mNasaReference - m24sim(ii))/mNasaReference * 100.
  write (*, '("Momentum (p=m*v):", T18, 2(1PD15.7,4x))') m23(ii)*v23(ii), m24sim(ii)*v24sim(ii)
  NKTg1 = [x23(ii)*m23(ii)*v23(ii), X24sim(ii)*m24sim(ii)*v24sim(ii)]
  write (*, '("NKTg1=x*p:", T18, 2(1PD15.7,4x))') NKTg1
  NKTg2 = [dmdt23(ii)*m23(ii)*v23(ii), dmdt224sim(ii)*m24sim(ii)*v24sim(ii)]
  write (*, '("NKTg2=dm/dt*p:", T18, 2(1PD15.7,4x))')  NKTg2           ! 14 orders of magnitude smaller than NKTg1
  totalNKT = sqrt (NKTg1**2 + NKTg2 ** 2)
  write (*, '("Total NKTg:", T18, 2(1PD15.7,4x))')  totalNKT           ! Expect no visible difference to NKTg1
enddo


end program NKTg_Neptune

