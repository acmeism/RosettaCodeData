module cyk_parser
    implicit none

    integer, parameter :: MAX_RULES = 20
    integer, parameter :: MAX_RHS = 10
    integer, parameter :: MAX_WORDS = 100
    integer, parameter :: MAX_SETS = 50
    integer, parameter :: STR_LEN = 20

    type :: rule_type
        character(len=STR_LEN) :: lhs
        integer :: n_rhs
        character(len=STR_LEN) :: rhs(MAX_RHS, 2)
        integer :: rhs_len(MAX_RHS)
    end type rule_type

    type :: set_type
        character(len=STR_LEN) :: elements(MAX_SETS)
        integer :: count
    end type set_type

contains

    subroutine add_to_set(s, element)
        type(set_type), intent(inout) :: s
        character(len=*), intent(in) :: element
        integer :: i

        ! Check if element already exists
        do i = 1, s%count
            if (trim(s%elements(i)) == trim(element)) return
        end do

        ! Add new element
        s%count = s%count + 1
        s%elements(s%count) = element
    end subroutine add_to_set

    function is_in_set(s, element) result(found)
        type(set_type), intent(in) :: s
        character(len=*), intent(in) :: element
        logical :: found
        integer :: i

        found = .false.
        do i = 1, s%count
            if (trim(s%elements(i)) == trim(element)) then
                found = .true.
                return
            end if
        end do
    end function is_in_set

    function cyk_parse(words, n_words, rules, n_rules) result(valid)
        character(len=STR_LEN), intent(in) :: words(MAX_WORDS)
        integer, intent(in) :: n_words, n_rules
        type(rule_type), intent(in) :: rules(MAX_RULES)
        logical :: valid

        type(set_type) :: t(MAX_WORDS, MAX_WORDS)
        integer :: i, j, k, r, rhs_idx

        ! Initialize all sets
        do i = 1, n_words
            do j = 1, n_words
                t(i, j)%count = 0
            end do
        end do

        ! Main CYK algorithm
        do j = 1, n_words
            ! Fill diagonal (single terminals)
            do r = 1, n_rules
                do rhs_idx = 1, rules(r)%n_rhs
                    if (rules(r)%rhs_len(rhs_idx) == 1) then
                        if (trim(rules(r)%rhs(rhs_idx, 1)) == trim(words(j))) then
                            call add_to_set(t(j, j), rules(r)%lhs)
                        end if
                    end if
                end do
            end do

            ! Fill column j from diagonal up
            do i = j - 1, 1, -1
                do k = i, j - 1
                    do r = 1, n_rules
                        do rhs_idx = 1, rules(r)%n_rhs
                            if (rules(r)%rhs_len(rhs_idx) == 2) then
                                if (is_in_set(t(i, k), rules(r)%rhs(rhs_idx, 1)) .and. &
                                    is_in_set(t(k+1, j), rules(r)%rhs(rhs_idx, 2))) then
                                    call add_to_set(t(i, j), rules(r)%lhs)
                                end if
                            end if
                        end do
                    end do
                end do
            end do
        end do

        valid = is_in_set(t(1, n_words), "NP")
    end function cyk_parse

end module cyk_parser

program test_cyk
    use cyk_parser
    implicit none

    type(rule_type) :: rules(MAX_RULES)
    character(len=STR_LEN) :: words(MAX_WORDS)
    integer :: n_rules, n_words
    logical :: result

    ! Initialize grammar rules
    n_rules = 0

    ! NP -> Det Nom
    n_rules = n_rules + 1
    rules(n_rules)%lhs = "NP"
    rules(n_rules)%n_rhs = 1
    rules(n_rules)%rhs(1, 1) = "Det"
    rules(n_rules)%rhs(1, 2) = "Nom"
    rules(n_rules)%rhs_len(1) = 2

    ! Nom -> AP Nom
    n_rules = n_rules + 1
    rules(n_rules)%lhs = "Nom"
    rules(n_rules)%n_rhs = 4
    rules(n_rules)%rhs(1, 1) = "AP"
    rules(n_rules)%rhs(1, 2) = "Nom"
    rules(n_rules)%rhs_len(1) = 2
    rules(n_rules)%rhs(2, 1) = "book"
    rules(n_rules)%rhs_len(2) = 1
    rules(n_rules)%rhs(3, 1) = "orange"
    rules(n_rules)%rhs_len(3) = 1
    rules(n_rules)%rhs(4, 1) = "man"
    rules(n_rules)%rhs_len(4) = 1

    ! AP -> Adv A, heavy, orange, tall
    n_rules = n_rules + 1
    rules(n_rules)%lhs = "AP"
    rules(n_rules)%n_rhs = 4
    rules(n_rules)%rhs(1, 1) = "Adv"
    rules(n_rules)%rhs(1, 2) = "A"
    rules(n_rules)%rhs_len(1) = 2
    rules(n_rules)%rhs(2, 1) = "heavy"
    rules(n_rules)%rhs_len(2) = 1
    rules(n_rules)%rhs(3, 1) = "orange"
    rules(n_rules)%rhs_len(3) = 1
    rules(n_rules)%rhs(4, 1) = "tall"
    rules(n_rules)%rhs_len(4) = 1

    ! Det -> a
    n_rules = n_rules + 1
    rules(n_rules)%lhs = "Det"
    rules(n_rules)%n_rhs = 1
    rules(n_rules)%rhs(1, 1) = "a"
    rules(n_rules)%rhs_len(1) = 1

    ! Adv -> very, extremely
    n_rules = n_rules + 1
    rules(n_rules)%lhs = "Adv"
    rules(n_rules)%n_rhs = 2
    rules(n_rules)%rhs(1, 1) = "very"
    rules(n_rules)%rhs_len(1) = 1
    rules(n_rules)%rhs(2, 1) = "extremely"
    rules(n_rules)%rhs_len(2) = 1

    ! A -> heavy, orange, tall, muscular
    n_rules = n_rules + 1
    rules(n_rules)%lhs = "A"
    rules(n_rules)%n_rhs = 4
    rules(n_rules)%rhs(1, 1) = "heavy"
    rules(n_rules)%rhs_len(1) = 1
    rules(n_rules)%rhs(2, 1) = "orange"
    rules(n_rules)%rhs_len(2) = 1
    rules(n_rules)%rhs(3, 1) = "tall"
    rules(n_rules)%rhs_len(3) = 1
    rules(n_rules)%rhs(4, 1) = "muscular"
    rules(n_rules)%rhs_len(4) = 1

    ! Test string: "a very heavy orange book"
    n_words = 5
    words(1) = "a"
    words(2) = "very"
    words(3) = "heavy"
    words(4) = "orange"
    words(5) = "book"

    result = cyk_parse(words, n_words, rules, n_rules)

    print *, "CYK Parse Result: ", result

end program test_cyk
