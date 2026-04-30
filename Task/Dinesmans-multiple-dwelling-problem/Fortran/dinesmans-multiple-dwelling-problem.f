program apartment_puzzle
  implicit none
  integer :: domains(5,5)  ! domains(person, floor) = 1 if possible
  integer :: solution(5)
  logical :: found

  ! Initialize: all assignments possible, solution unassigned
  domains = 1
  solution = 0

  ! Apply unary constraints
  domains(1, 5) = 0  ! Baker not on top
  domains(2, 1) = 0  ! Cooper not on bottom
  domains(3, 1) = 0  ! Fletcher not on bottom
  domains(3, 5) = 0  ! Fletcher not on top

  call solve_csp(domains, solution, 1, found)

  if (found) then
    print *, "Baker:   ", solution(1)
    print *, "Cooper:  ", solution(2)
    print *, "Fletcher:", solution(3)
    print *, "Miller:  ", solution(4)
    print *, "Smith:   ", solution(5)
  else
    print *, "No solution found"
  end if

contains

  recursive subroutine solve_csp(dom, sol, person, found)
    integer, intent(in) :: dom(5,5)
    integer, intent(inout) :: sol(5)
    integer, intent(in) :: person
    logical, intent(out) :: found
    integer :: floor, new_dom(5,5)

    if (person > 5) then
      found = check_all_constraints(sol)
      return
    end if

    found = .false.
    do floor = 1, 5
      if (dom(person, floor) == 0) cycle
      if (any(sol(1:person-1) == floor)) cycle  ! Floor already taken

      sol(person) = floor

      ! Check constraints so far
      if (.not. check_partial_constraints(sol, person)) then
        sol(person) = 0
        cycle
      end if

      ! Forward check: propagate constraints
      new_dom = dom
      new_dom(:, floor) = 0  ! Remove this floor from remaining

      call solve_csp(new_dom, sol, person + 1, found)
      if (found) return

      sol(person) = 0
    end do
  end subroutine

  function check_partial_constraints(sol, up_to) result(valid)
    integer, intent(in) :: sol(5), up_to
    logical :: valid

    valid = .true.

    ! Miller > Cooper (if both assigned)
    if (up_to >= 4 .and. sol(4) > 0 .and. sol(2) > 0) then
      if (sol(4) <= sol(2)) valid = .false.
    end if

    ! Smith not adjacent Fletcher (if both assigned)
    if (up_to >= 5 .and. sol(5) > 0 .and. sol(3) > 0) then
      if (abs(sol(5) - sol(3)) == 1) valid = .false.
    end if

    ! Fletcher not adjacent Cooper (if both assigned)
    if (up_to >= 3 .and. sol(3) > 0 .and. sol(2) > 0) then
      if (abs(sol(3) - sol(2)) == 1) valid = .false.
    end if
  end function

  function check_all_constraints(sol) result(valid)
    integer, intent(in) :: sol(5)
    logical :: valid

    valid = check_partial_constraints(sol, 5)
  end function

end program
