! Display a linear combination
! tested with Intel ifx (IFX) 2025.2.0 20250605             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! Note that VMS requires switch $Fortran/ccdefault=LIST
! otherwise 1st character of each output line is interpreted as
! Carriage Control character.
!
! U.B., July 2025
!
program LinearCombinations

implicit none

! All test cases from Task Description
!
call showLinearCombinations ([1,  2,  3])
call showLinearCombinations ([0,  1,  2,  3])
call showLinearCombinations ([1,  0,  3,  4])
call showLinearCombinations ([1,  2,  0])
call showLinearCombinations ([0,  0,  0])
call showLinearCombinations ([0])
call showLinearCombinations ([1,  1,  1])
call showLinearCombinations ([-1, -1, -1])
call showLinearCombinations ([-1, -2,  0, -3])
call showLinearCombinations ([-1])

contains

subroutine showLinearCombinations (v)

  integer, intent(in) :: v(:)         ! Vector of coefficients
  integer :: i                        ! Loop index
  logical :: firstTerm                ! Indicates first non-zero term of each case

  firstTerm = .true.

  ! Now iterate through array of coefficients. Care for proper spacing.
  ! Special cases:
  !   coefficients 0: do nothing, just skip it.
  !   coefficients 1 or -1: do not print 1 as factor for e(i)
  !   all others:
  !     first term:
  !        if negative: print coefficient with minus sign
  !        if positive: print  coeffivient without sign indicator.
  !     all others; add/subtract  with spacing " + " resp. " - "

  do i=1,size(v)
    if (v(i) .eq. 0) then
      ! zero coefficient: do nothing

    else if (v(i) .eq. 1) then
      ! coefficient is 1: dont print factor '1', just e(i)
      if (.not.firstTerm) write (6,'(" + ")', advance='no')   ! first term is not added
      write (6,'("e(", i0, ")")', advance='no')  i
      firstTerm = .false.

    else if (v(i) .eq. -1) then
      ! coefficient is -1: dont print factor '-1', just "-e(i)" or "- e(i)"
      if (firstTerm) then
        write (6,'("-")', advance='no')         ! first term not subtracted, write -e(i)
      else
        write (6,'(" - ")', advance='no')       ! subtract with spacing "- e(i)"
      endif
      write (6,'("e(", i0, ")")', advance='no')  i
      firstTerm = .false.

    else if (v(i) .gt. 0) then
      ! positive coefficient c: write "+ c*e(i)" except at start of line
      if (.not.firstTerm) write (6,'(" + ")', advance='no')   ! no '+' at beginning of line
      write (6,'(i0, "*e(", i0, ")")', advance='no') v(i),  i
      firstTerm = .false.

    else if (v(i) .lt. 0) then
      ! Negative coefficient c: write "- c*e(i)" if not fist term, otherwise with sign '-'
      if (.not.firstTerm) then
        write (6,'(" - ")', advance='no')               ! minus with spacing
        write (6,'(i0, "*e(", i0, ")")', advance='no') abs(v(i)),  i
      else
        write (6,'(i0, "*e(", i0, ")")', advance='no')  v(i),  i
      end if
      firstTerm = .false.
    end if
  end do

  if (firstTerm)  then
    write (6,'("0")')   ! no non-zero terms so far: print '0'
  else
    write (6,*)         ! printed some non-zero terms, terminate line.
  end if

end subroutine showLinearCombinations

end program LinearCombinations
