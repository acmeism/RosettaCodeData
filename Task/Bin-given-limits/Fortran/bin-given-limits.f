!
! Bin given limits
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
! VSI Fortran (V8.6) does compile this code because it
! does not like the dimension (*) of the parameters
! U.B., January 2026
!==============================================================================
program binLimits

implicit none

! Limits and Data for first example from task description
integer, parameter :: limits1 (*) = [23, 37, 43, 53, 67, 83 ]
integer, parameter :: values1 (*) = [95,21,94,12,99,4,70,75,83,93,52,80,57,5,53,86,65,17,92,83,71,61,54,58,47,   &
          16, 8, 9,32,84,7,87,46,19,30,37,96,6,98,40,79,97,45,64,60,29,49,36,43,55]

! Second example
integer, parameter :: limits2 (*) = [14, 18, 249, 312, 389, 392, 513, 591, 634, 720]
integer, parameter :: values2 (*) = [445,814,519,697,700,130,255,889,481,122,932, 77,323,525,570,219,367,523,442,933,    &
           416,589,930,373,202,253,775, 47,731,685,293,126,133,450,545,100,741,583,763,306,   &
           655,267,248,477,549,238, 62,678, 98,534,622,907,406,714,184,391,913, 42,560,247,   &
           346,860, 56,138,546, 38,985,948, 58,213,799,319,390,634,458,945,733,507,916,123,   &
           345,110,720,917,313,845,426,  9,457,628,410,723,354,895,881,953,677,137,397, 97,   &
           854,740, 83,216,421, 94,517,479,292,963,376,981,480, 39,257,272,157,  5,316,395,   &
           787,942,456,242,759,898,576, 67,298,425,894,435,831,241,989,614,987,770,384,692,   &
           698,765,331,487,251,600,879,342,982,527,736,795,585, 40, 54,901,408,359,577,237,   &
           605,847,353,968,832,205,838,427,876,959,686,646,835,127,621,892,443,198,988,791,   &
           466, 23,707,467, 33,670,921,180,991,396,160,436,717,918,  8,374,101,684,727,749]

call solve (limits1, size(limits1), values1, size(values1))
call solve (limits2, size(limits2), values2, size(values2))

contains

! ==================================================
! Create array of Histogram bins, then print results
! ==================================================
subroutine solve (l, nl, v,nv)
integer, intent(in) :: nl, nv                 ! Array sizes
integer, intent(in) :: l(nl), v(nv)           ! Limits and Data arryays
integer :: hist (0:nl)                        ! THe resultant histogram

call build_Histogram (l,nl,v,nv,hist)
call print_LimitsAndHistogram (l,nl,hist)

end subroutine solve


! ==============================
! Create array of Histogram bins
! ==============================
subroutine build_Histogram (l,nl,v,nv,hist)

integer, intent(in) :: nl, nv                 ! Array sizes
integer, intent(in) :: l(nl), v(nv)           ! Limits and Data arryays
integer,intent(out) :: hist (0:nl)            ! The resultant histogram

integer :: iv, il                             ! Loop indices into values and limits

hist = 0
do iv=1, nv
  ! If number of limits nl is small (here: 5 resp. 10), linear search for bin is sufficient.
  ! for large nl consider to use binary search, that can be more efficient.
  do il= nl, 1, -1
    if (v(iv) .ge. l(il)) then
      hist(il) = hist(il) + 1
      exit
    else if (il .eq. 1) then
      hist(0) = hist(0) + 1
    end if
  end do
end do

end subroutine build_Histogram

subroutine print_LimitsAndHistogram (l,nl,hist)

integer, intent(in) :: nl                     ! Array size
integer, intent(in) :: l(nl)                  ! Limits to print
integer, intent(in) :: hist (0:nl)            ! Histogram values to print

integer :: il                                  ! Loop index

do il=0, nl
  if (il .eq. 0) then
    write (*,'("           < ", i3, ": ", i3)')    l(1), hist(il)
  else if (il .lt. nl) then
    write (*,'(">= ", i3, " ... < ", i3, ": ", i3)')    l(il), l(il+1), hist(il)
  else
    write (*,'(">= ", i3, "          : ", i3)')    l(il) , hist(il)
  end if
end do
write (*,*) ! 1 empty line

end subroutine print_LimitsAndHistogram

end program binLimits
