! Experimental Verification of the NKT Law: Interpolating the Masses ...
! ...of 8 Planets Using NASA Data as of 30–31/12/2024
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., March 2026
!
program NKT30122024
implicit none

integer, parameter :: DP=8

character (len=7), dimension(8), parameter :: Planets = &   ! gfortran expects all with same length
& ["Mercury", "Venus  ","Earth  ","Mars   ","Jupiter","Saturn ","Uranus ","Neptune"]

real (kind=DP), dimension(8) :: x &
 = [6.9817930E7,  1.08939000E8,  1.47100000E8, 2.49230000E8, &
    8.16620000E8, 1.506530000E9, 3.00139000E9, 4.55890000E9], &
 v = [38.86, 35.02, 29.29, 24.07, 13.06, 9.69, 6.8, 5.43], &
 NKTg1 = [8.951E32, 1.858E34, 2.571E34, 3.850E33, &
          2.024E37, 8.303E36, 1.772E36, 2.534E36 ], &
 mNASA = [3.301E23, 4.867E24, 5.972E24, 6.417E23, &
          1.898E27, 5.683E26, 8.681E25, 1.024E26]



! 1. Interpolated Mass:   m = NKTg1 / (x·v)
!
! 2. Linear momentum: p=m*v
!
! 3. Absolute difference compared to NASA mass:
!      Δm = |m_NASA - m|
!
! Taking the NASA mass, multiplying it with v to obtain a linear momentum, then multiplying this with x
! to obtain a value of NTKg1, and dividing that NKTg1 value by (x*v) to obtain a mass
! is equivalent to multiply the NASA mass by 1.000, the result is the mass.
!
! If we use the NTKTg1 values given in the text, and the x and v values, we can calculate
! eight masses, that are presumably the values that have been used to calculate these NKTg1
! Again, this is questionable.

real (kind=DP) :: m, p, ourOwnNKTG1
integer :: ii

write (*,'(A)') "1.: The data set of 30/12/2024 contains values for x, v, and NKTg1 for all 8 planets."
write (*,'(A)') '    Using these to calculate plant masses gives: '
do  ii=1, 8
  write (*,'(/,A,":", /)') Planets(ii) (:len_trim(Planets(ii)))
  write (*,'("NASA mass", T30,"= ", 1PD17.10)')  mNASA(ii)
  m = NKTG1(ii) / (x(ii)*v(ii))
  write (*,'("Interpolated Mass", T30,"= ", 1PD17.10)')  m
  write (*,'("Mass Difference to NASA", T30,"= ", 1PD17.10)')   abs (mNASA(ii) - m)
  write (*,'("Percentual Mass Difference", T30,"= ", F6.3, "%")')   abs (mNASA(ii) - m) / mNASA(ii) * 100.
enddo

write (*,'(//,A)') "2.: Using the NASA masses of the planets and the x and v values from the"
write (*,'(A)') "    data set of 30/12/2024 we can calculate NKTG1 values for all 8 planets."
write (*,'(A)') '    Using these to calculate planet masses gives the NASA masses again: '

do  ii=1, 8
  write (*,'(/,A,":", /)') Planets(ii) (:len_trim(Planets(ii)))
  ourOwnNKTG1 = x(ii) * mNASA(ii)*v(ii)
  Write (*, '("NKTg1(=NASA mass *x*v)", T30,"= ", 1PD17.10)') ourOwnNKTG1
  m = ourOwnNKTG1 / (x(ii)*v(ii))
  write (*,'("NASA mass", T30,"= ", 1PD17.10)')  mNASA(ii)
  write (*,'("Interpolated Mass", T30,"= ", 1PD17.10)')  m
  write (*,'("Mass Difference to NASA", T30,"= ", 1PD17.10)')   abs (mNASA(ii) - m)
end do


end program NKT30122024
