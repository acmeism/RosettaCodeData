! This is free and unencumbered software released into the public domain,
! via the Unlicense.
! For more information, please refer to <http://unlicense.org/>

program no_connection_puzzle

  implicit none

  ! The names of the holes.
  integer, parameter :: a = 1
  integer, parameter :: b = 2
  integer, parameter :: c = 3
  integer, parameter :: d = 4
  integer, parameter :: e = 5
  integer, parameter :: f = 6
  integer, parameter :: g = 7
  integer, parameter :: h = 8

  integer :: holes(a:h)

  call find_solutions (holes, a)

contains

  recursive subroutine find_solutions (holes, current_hole_index)
    integer, intent(inout) :: holes(a:h)
    integer, intent(in) :: current_hole_index

    integer :: peg_number

    ! Recursively construct and print possible solutions, quitting
    ! any partial solution that does not satisfy constraints.
    do peg_number = 1, 8
       holes(current_hole_index) = peg_number
       if (satisfies_the_constraints (holes, current_hole_index)) then
          if (current_hole_index == h) then
             call print_solution (holes)
             write (*, '()')
          else
             call find_solutions (holes, current_hole_index + 1)
          end if
       end if
    end do
  end subroutine find_solutions

  function satisfies_the_constraints (holes, i) result (satisfies)
    integer, intent(inout) :: holes(a:h)
    integer, intent(in) :: i    ! Where the new peg goes.
    logical :: satisfies

    integer :: j

    ! The most recently inserted peg must not be a duplicate of one
    ! already inserted.
    satisfies = all (holes(a : i - 1) /= holes(i))

    if (satisfies) then
       ! ‘Fill’ the unfilled holes with fake pegs that cause
       ! differences with them always to be larger than 1.
       do j = i + 1, h
          holes(j) = 100 * j
       end do

       ! Check that the differences are satisfactory.
       satisfies = 1 < abs (holes(a) - holes(c)) .and.     &
            &      1 < abs (holes(a) - holes(d)) .and.     &
            &      1 < abs (holes(a) - holes(e)) .and.     &
            &      1 < abs (holes(c) - holes(g)) .and.     &
            &      1 < abs (holes(d) - holes(g)) .and.     &
            &      1 < abs (holes(e) - holes(g)) .and.     &
            &      1 < abs (holes(b) - holes(d)) .and.     &
            &      1 < abs (holes(b) - holes(e)) .and.     &
            &      1 < abs (holes(b) - holes(f)) .and.     &
            &      1 < abs (holes(d) - holes(h)) .and.     &
            &      1 < abs (holes(e) - holes(h)) .and.     &
            &      1 < abs (holes(f) - holes(h)) .and.     &
            &      1 < abs (holes(c) - holes(d)) .and.     &
            &      1 < abs (holes(d) - holes(e)) .and.     &
            &      1 < abs (holes(e) - holes(f))
    end if
  end function satisfies_the_constraints

  subroutine print_solution (holes)
    integer, intent(in) :: holes(a:h)

    write (*, '(I5, I4)') holes(a), holes(b)
    write (*, '("   /│\ /│\")')
    write (*, '("  / │ X │ \")')
    write (*, '(" /  │/ \│  \")')
    write (*, '(3(I1, "───"), I1)') holes(c), holes(d), holes(e), holes(f)
    write (*, '(" \  │\ /│  /")')
    write (*, '("  \ │ X │ /")')
    write (*, '("   \│/ \│/")')
    write (*, '(I5, I4)') holes(g), holes(h)
  end subroutine print_solution

end program no_connection_puzzle
