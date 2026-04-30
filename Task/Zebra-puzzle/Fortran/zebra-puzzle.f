program zebra_clean
    implicit none

    integer, parameter :: RED=1, GREEN=2, WHITE=3, BLUE=4, YELLOW=5
    integer, parameter :: ENGLISH=1, SWEDE=2, DANE=3, NORWEGIAN=4, GERMAN=5
    integer, parameter :: DOG=1, CAT=2, BIRD=3, HORSE=4, ZEBRA=5
    integer, parameter :: TEA=1, COFFEE=2, MILK=3, BEER=4, WATER=5
    integer, parameter :: PALLMALL=1, DUNHILL=2, BLEND=3, BLUEMASTER=4, PRINCE=5

    integer :: solution(5,5)  ! (house, attribute): color, nation, pet, drink, smoke
    integer(kind=8) :: count
    integer :: num_solutions

    count = 0
    num_solutions = 0

    print *, "Solving Einstein's Zebra Puzzle..."
    print *

    call solve(1, 1, solution, count, num_solutions)

    print *
    print '(A,I0)', "Total permutations tried: ", count
    print '(A,I0)', "Solutions found: ", num_solutions
    if (num_solutions == 1) print *, "Solution is UNIQUE!"

contains

    recursive subroutine solve(house, attr, sol, cnt, nsol)
        integer, intent(in) :: house, attr
        integer, intent(inout) :: sol(5,5)
        integer(kind=8), intent(inout) :: cnt
        integer, intent(inout) :: nsol
        integer :: val

        ! If all houses and attributes filled, check solution
        if (house > 5) then
            cnt = cnt + 1
            if (is_valid_solution(sol)) then
                nsol = nsol + 1
                call print_sol(sol, nsol)
            end if
            return
        end if

        ! Move to next position
        if (attr > 5) then
            call solve(house+1, 1, sol, cnt, nsol)
            return
        end if

        ! Try each possible value for this attribute
        do val = 1, 5
            if (can_place(sol, house, attr, val)) then
                sol(house, attr) = val
                if (satisfies_constraints(sol, house, attr)) then
                    call solve(house, attr+1, sol, cnt, nsol)
                end if
                sol(house, attr) = 0
            end if
        end do
    end subroutine

    function can_place(sol, house, attr, val) result(ok)
        integer, intent(in) :: sol(5,5), house, attr, val
        logical :: ok
        integer :: h

        ! Check if value already used in this attribute
        ok = .true.
        do h = 1, house-1
            if (sol(h, attr) == val) then
                ok = .false.
                return
            end if
        end do

        ! Handle fixed constraints
        ! Constraint 9: Middle house drinks milk
        if (attr == 4 .and. house == 3 .and. val /= MILK) then
            ok = .false.
            return
        end if
        if (attr == 4 .and. house /= 3 .and. val == MILK) then
            ok = .false.
            return
        end if

        ! Constraint 10: Norwegian in first house
        if (attr == 2 .and. house == 1 .and. val /= NORWEGIAN) then
            ok = .false.
            return
        end if
        if (attr == 2 .and. house /= 1 .and. val == NORWEGIAN) then
            ok = .false.
            return
        end if
    end function

    function satisfies_constraints(sol, house, attr) result(ok)
        integer, intent(in) :: sol(5,5), house, attr
        logical :: ok
        integer :: i

        ok = .true.

        ! Only check constraints for completed houses
        do i = 1, house
            if (any(sol(i,:) == 0)) cycle  ! House not complete

            ! Constraint 2: English in red
            if ((sol(i,2) == ENGLISH .and. sol(i,1) /= RED) .or. &
                (sol(i,1) == RED .and. sol(i,2) /= ENGLISH)) then
                ok = .false.
                return
            end if

            ! Constraint 3: Swede has dog
            if ((sol(i,2) == SWEDE .and. sol(i,3) /= DOG) .or. &
                (sol(i,3) == DOG .and. sol(i,2) /= SWEDE)) then
                ok = .false.
                return
            end if

            ! Constraint 4: Dane drinks tea
            if ((sol(i,2) == DANE .and. sol(i,4) /= TEA) .or. &
                (sol(i,4) == TEA .and. sol(i,2) /= DANE)) then
                ok = .false.
                return
            end if

            ! Constraint 6: Coffee in green
            if ((sol(i,1) == GREEN .and. sol(i,4) /= COFFEE) .or. &
                (sol(i,4) == COFFEE .and. sol(i,1) /= GREEN)) then
                ok = .false.
                return
            end if

            ! Constraint 7: Pall Mall has bird
            if ((sol(i,5) == PALLMALL .and. sol(i,3) /= BIRD) .or. &
                (sol(i,3) == BIRD .and. sol(i,5) /= PALLMALL)) then
                ok = .false.
                return
            end if

            ! Constraint 8: Yellow smokes Dunhill
            if ((sol(i,1) == YELLOW .and. sol(i,5) /= DUNHILL) .or. &
                (sol(i,5) == DUNHILL .and. sol(i,1) /= YELLOW)) then
                ok = .false.
                return
            end if

            ! Constraint 13: Blue Master drinks beer
            if ((sol(i,5) == BLUEMASTER .and. sol(i,4) /= BEER) .or. &
                (sol(i,4) == BEER .and. sol(i,5) /= BLUEMASTER)) then
                ok = .false.
                return
            end if

            ! Constraint 14: German smokes Prince
            if ((sol(i,2) == GERMAN .and. sol(i,5) /= PRINCE) .or. &
                (sol(i,5) == PRINCE .and. sol(i,2) /= GERMAN)) then
                ok = .false.
                return
            end if

            ! Constraint 5: Green immediately left of white
            if (i < 5) then
                if (sol(i,1) == GREEN .and. sol(i+1,1) /= 0 .and. sol(i+1,1) /= WHITE) then
                    ok = .false.
                    return
                end if
            end if
            if (i > 1) then
                if (sol(i,1) == WHITE .and. sol(i-1,1) /= GREEN) then
                    ok = .false.
                    return
                end if
            end if
        end do
    end function

    function is_valid_solution(sol) result(valid)
        integer, intent(in) :: sol(5,5)
        logical :: valid

        valid = .false.

        ! Check all constraints on complete solution
        if (.not. check_pair(sol, 2, ENGLISH, 1, RED)) return
        if (.not. check_pair(sol, 2, SWEDE, 3, DOG)) return
        if (.not. check_pair(sol, 2, DANE, 4, TEA)) return
        if (.not. check_adjacent_left(sol, 1, GREEN, 1, WHITE)) return
        if (.not. check_pair(sol, 1, GREEN, 4, COFFEE)) return
        if (.not. check_pair(sol, 5, PALLMALL, 3, BIRD)) return
        if (.not. check_pair(sol, 1, YELLOW, 5, DUNHILL)) return
        if (sol(3,4) /= MILK) return
        if (sol(1,2) /= NORWEGIAN) return
        if (.not. check_adjacent(sol, 5, BLEND, 3, CAT)) return
        if (.not. check_adjacent(sol, 3, HORSE, 5, DUNHILL)) return
        if (.not. check_pair(sol, 5, BLUEMASTER, 4, BEER)) return
        if (.not. check_pair(sol, 2, GERMAN, 5, PRINCE)) return
        if (.not. check_adjacent(sol, 2, NORWEGIAN, 1, BLUE)) return
        if (.not. check_adjacent(sol, 4, WATER, 5, BLEND)) return

        valid = .true.
    end function

    function check_pair(sol, attr1, val1, attr2, val2) result(ok)
        integer, intent(in) :: sol(5,5), attr1, val1, attr2, val2
        logical :: ok
        integer :: i
        ok = .false.
        do i = 1, 5
            if (sol(i, attr1) == val1 .and. sol(i, attr2) == val2) then
                ok = .true.
                return
            end if
        end do
    end function

    function check_adjacent_left(sol, attr1, val1, attr2, val2) result(ok)
        integer, intent(in) :: sol(5,5), attr1, val1, attr2, val2
        logical :: ok
        integer :: i
        ok = .false.
        do i = 1, 4
            if (sol(i, attr1) == val1 .and. sol(i+1, attr2) == val2) then
                ok = .true.
                return
            end if
        end do
    end function

    function check_adjacent(sol, attr1, val1, attr2, val2) result(ok)
        integer, intent(in) :: sol(5,5), attr1, val1, attr2, val2
        logical :: ok
        integer :: i, pos1, pos2
        pos1 = 0
        pos2 = 0
        do i = 1, 5
            if (sol(i, attr1) == val1) pos1 = i
            if (sol(i, attr2) == val2) pos2 = i
        end do
        ok = (abs(pos1 - pos2) == 1)
    end function

    subroutine print_sol(sol, num)
        integer, intent(in) :: sol(5,5), num
        integer :: i, zebra_house

        character(len=12) :: colors(5), nations(5), pets(5), drinks(5), smokes(5)

        colors = ['Red         ', 'Green       ', 'White       ', 'Blue        ', 'Yellow      ']
        nations = ['English     ', 'Swede       ', 'Dane        ', 'Norwegian   ', 'German      ']
        pets = ['Dog         ', 'Cat         ', 'Bird        ', 'Horse       ', 'Zebra       ']
        drinks = ['Tea         ', 'Coffee      ', 'Milk        ', 'Beer        ', 'Water       ']
        smokes = ['Pall Mall   ', 'Dunhill     ', 'Blend       ', 'Blue Master ', 'Prince      ']

        print *, "================================"
        print '(A,I0)', "Solution #", num
        print *, "================================"
        print *
        print *, "House | Color       | Nation      | Pet         | Drink       | Smoke"
        print *, "------+-------------+-------------+-------------+-------------+-------------"
100 format(I0,T7,A,T12,A,T21,A,T24,A,T35,A,T38,A,T49,A,T52,A,T63,A,T66,A)
        do i = 1, 5
            print 100, i, ' | ', &
                trim(adjustl(colors(sol(i,1)))), ' | ', &
                trim(nations(sol(i,2))), ' | ', &
                trim(pets(sol(i,3))), ' | ', &
                trim(drinks(sol(i,4))), ' | ', &
                trim(smokes(sol(i,5)))
        end do

        print *

        zebra_house = 0
        do i = 1, 5
            if (sol(i,3) == ZEBRA) then
                zebra_house = i
                exit
            end if
        end do

        print *, "*** THE ZEBRA IS OWNED BY THE ", trim(nations(sol(zebra_house,2))), " ***"
        print *
    end subroutine

end program zebra_clean
