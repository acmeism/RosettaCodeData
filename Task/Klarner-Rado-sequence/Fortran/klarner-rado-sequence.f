! Klarner-Rado sequence
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 26.04
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 26.04
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., July 2026

program KlarnerRado
implicit none

integer, parameter :: limit = 10000000
integer, dimension(limit) :: Klarner_Rado

integer :: i

call initialise_klarner_rado_sequence ()
write (*,'(A)') 'The first 100 elements of the Klarner-Rado sequence:'
do i=1,100
  write (*, '(I5,x)', advance='no')    Klarner_Rado(i)
  if (mod (i,10) .eq. 0) write (*,*)                        ! Terminate line after 10 entries
end do

i = 100
write (*,*)                                                 ! 1 blank line
do while (i .lt. limit)
  write (*,'("The ",i7, "th element of the Klarner-Rado sequence is ", i8)' ) i, Klarner_Rado(i)
  i = 10 * i
enddo
contains

!
! fill main program's array Klarner_Rado
!
subroutine initialise_klarner_rado_sequence()

integer :: i, i2, i3, minimum, m2, m3

! Initial values as in C++ solution
i2=1
i3=1
m2=1
m3=1

do i=1, limit
  ! Find the minimum of the next potential candidates
  minimum = MIN (m2, m3)
  Klarner_Rado (i) = minimum

  ! If the minimum came from the 2*x + 1 rule, generate the next
  ! candidate using the next element from the sequence for that rule.
  if (m2 .eq. minimum) then
    m2 = Klarner_Rado(i2)*2 + 1
    i2 = i2 + 1
  endif

  ! If the minimum came from the 3*x + 1 rule, generate the next
  ! candidate using the next element from the sequence for that rule.
  !NOTE: This is NOT an else-if. If m2 == m3, both need to advance.
  if (m3 .eq. minimum) then
    m3 = Klarner_Rado(i3)*3 + 1
    i3 = i3 + 1
  endif
end do

end subroutine initialise_klarner_rado_sequence

end program KlarnerRado
