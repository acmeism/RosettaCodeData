! regex_engine.f90
! McNaughton-Yamada-Thompson (Thompson's Construction) Algorithm
! Converts a regular expression to a Non-Deterministic Finite Automaton (NFA)
! and uses the NFA to match input strings.
!
! Supported operators (explicit, no implicit concatenation):
!   .   concatenation        a.b  matches "ab"
!   |   alternation          a|b  matches "a" or "b"
!   *   Kleene star          a*   matches "", "a", "aa", ...
!   +   one-or-more          a+   matches "a", "aa", ...
!   ?   optional             a?   matches "" or "a"
!   ()  grouping
!
! Algorithm overview:
!   1. Shunting-Yard converts infix regex to postfix (RPN).
!   2. Postfix tokens are consumed left-to-right; each literal pushes a
!      two-state NFA fragment; each operator pops fragment(s), wires them
!      together per Thompson's rules, and pushes the result.
!   3. Matching simulates the NFA as a subset of active states:
!      start with the epsilon-closure of the initial state, then for each
!      input character move to reachable states via character transitions
!      followed by epsilon-closure.  Accept if the accept state is live
!      after all input is consumed.
!
! Bugs fixed from the original submission (Bwana Pete 24-Apr-2026)
! ----------------------------------------
! BUG 1 (wrong matches) -- implicit SAVE on initialised local variables
!   Any local variable declared with an initialiser, e.g.
!       integer :: stack_top = 0
!       logical :: visited(MAX_STATES) = .false.
!   acquires the SAVE attribute in Fortran.  The variable is initialised
!   only on the very first call; subsequent calls see the value left by
!   the previous call.  Three routines were affected:
!
!   a) get_epsilon_closure -- 'visited' retained true-flags from the
!      previous call, so every state appeared already-visited and the
!      closure was always empty after the first invocation.
!
!   b) compile_regex -- 'stack_top' kept its end-of-last-call value (1),
!      so each new NFA fragment was pushed at the wrong stack position and
!      the function returned a stale NFA from the previous pattern.
!
!   c) shunt -- 'stack_top' similarly retained its previous value, though
!      for well-formed regex it happens to end at 0 so this bug was latent.
!
!   Fix: removed the initialisers from all three declarations and added
!   explicit assignments (stack_top = 0, visited = .false.) as the first
!   executable statements of each routine.
!
! BUG 2 (minor robustness) -- compile_regex returned nfa_stack(1)
!   The original returned the first stack slot unconditionally.  For a
!   valid regex stack_top ends at 1, so this was harmless, but it is
!   cleaner and safer against malformed input to return nfa_stack(stack_top).
!
program regex_engine
    implicit none

    integer, parameter :: MAX_STATES  = 1000
    integer, parameter :: MAX_STACK   = 500
    integer, parameter :: MAX_POSTFIX = 200
    integer, parameter :: EPSILON     = 0
    integer, parameter :: NULL_STATE  = 0

    type :: state_type
        integer :: label
        integer :: edge1
        integer :: edge2
        logical :: is_used
    end type state_type

    type :: nfa_type
        integer :: initial
        integer :: accept
    end type nfa_type

    type(state_type) :: states(MAX_STATES)
    integer          :: next_state_id

    character(len=20) :: patterns(4) = [ &
        'a.b.c*              ', &
        'a.(b|d).c*          ', &
        '(a.(b|d))*          ', &
        'a.(b.b)*.c          ']
    character(len=10) :: test_strings(6) = [ &
        '          ', &
        'abc       ', &
        'abbc      ', &
        'abcc      ', &
        'abad      ', &
        'abbbc     ']

    integer :: i, j
    logical :: match_result

    write(*,'(A)') 'Pattern        String    Matched?'
    write(*,'(A)') repeat('_', 35)

    do i = 1, 4
        do j = 1, 6
            call init_states()
            match_result = match_regex(trim(patterns(i)), trim(test_strings(j)))
            write(*,'(A14, A10, L1)') adjustl(patterns(i)), adjustl(test_strings(j)), match_result
        end do
        write(*,*)
    end do

contains

    subroutine init_states()
        integer :: k
        do k = 1, MAX_STATES
            states(k)%label   = 0
            states(k)%edge1   = NULL_STATE
            states(k)%edge2   = NULL_STATE
            states(k)%is_used = .false.
        end do
        next_state_id = 1
    end subroutine init_states

    function new_state(label) result(state_id)
        integer, intent(in), optional :: label
        integer :: state_id

        if (next_state_id > MAX_STATES) then
            write(*,*) 'Error: Too many states'
            stop
        end if
        state_id = next_state_id
        next_state_id = next_state_id + 1
        states(state_id)%is_used = .true.
        if (present(label)) then
            states(state_id)%label = label
        else
            states(state_id)%label = EPSILON
        end if
        states(state_id)%edge1   = NULL_STATE
        states(state_id)%edge2   = NULL_STATE
    end function new_state

    subroutine shunt(infix, postfix, postfix_len)
        character(len=*), intent(in)  :: infix
        integer,          intent(out) :: postfix(MAX_POSTFIX)
        integer,          intent(out) :: postfix_len

        integer :: stack(MAX_STACK)
        integer :: stack_top          ! no initializer - avoids implicit SAVE
        integer :: i, c, precedence

        stack_top   = 0
        postfix_len = 0

        do i = 1, len_trim(infix)
            c = ichar(infix(i:i))

            if (c == ichar('(')) then
                stack_top = stack_top + 1
                stack(stack_top) = c

            else if (c == ichar(')')) then
                do while (stack_top > 0 .and. stack(stack_top) /= ichar('('))
                    postfix_len = postfix_len + 1
                    postfix(postfix_len) = stack(stack_top)
                    stack_top = stack_top - 1
                end do
                if (stack_top > 0) stack_top = stack_top - 1

            else if (is_operator(c)) then
                precedence = get_precedence(c)
                do while (stack_top > 0 .and. is_operator(stack(stack_top)) .and. &
                          precedence <= get_precedence(stack(stack_top)))
                    postfix_len = postfix_len + 1
                    postfix(postfix_len) = stack(stack_top)
                    stack_top = stack_top - 1
                end do
                stack_top = stack_top + 1
                stack(stack_top) = c

            else
                postfix_len = postfix_len + 1
                postfix(postfix_len) = c
            end if
        end do

        do while (stack_top > 0)
            postfix_len = postfix_len + 1
            postfix(postfix_len) = stack(stack_top)
            stack_top = stack_top - 1
        end do
    end subroutine shunt

    function is_operator(c) result(is_op)
        integer, intent(in) :: c
        logical :: is_op
        is_op = (c == ichar('*') .or. c == ichar('+') .or. c == ichar('?') .or. &
                 c == ichar('.') .or. c == ichar('|'))
    end function is_operator

    function get_precedence(c) result(prec)
        integer, intent(in) :: c
        integer :: prec
        select case (c)
        case (ichar('*')) ; prec = 60
        case (ichar('+')) ; prec = 55
        case (ichar('?')) ; prec = 50
        case (ichar('.')) ; prec = 40
        case (ichar('|')) ; prec = 20
        case default      ; prec = 0
        end select
    end function get_precedence

    subroutine get_epsilon_closure(state_id, closure, closure_size)
        integer, intent(in)  :: state_id
        integer, intent(out) :: closure(MAX_STATES)
        integer, intent(out) :: closure_size

        integer :: stack(MAX_STATES)
        integer :: stack_top              ! no initializer
        logical :: visited(MAX_STATES)    ! no initializer
        integer :: current

        stack_top    = 0
        visited      = .false.
        closure_size = 0

        if (state_id == NULL_STATE) return

        stack_top    = 1
        stack(1)     = state_id

        do while (stack_top > 0)
            current   = stack(stack_top)
            stack_top = stack_top - 1

            if (.not. visited(current)) then
                visited(current) = .true.
                closure_size = closure_size + 1
                closure(closure_size) = current

                if (states(current)%label == EPSILON) then
                    if (states(current)%edge1 /= NULL_STATE) then
                        stack_top = stack_top + 1
                        stack(stack_top) = states(current)%edge1
                    end if
                    if (states(current)%edge2 /= NULL_STATE) then
                        stack_top = stack_top + 1
                        stack(stack_top) = states(current)%edge2
                    end if
                end if
            end if
        end do
    end subroutine get_epsilon_closure

    function compile_regex(postfix, postfix_len) result(nfa)
        integer,      intent(in) :: postfix(MAX_POSTFIX)
        integer,      intent(in) :: postfix_len
        type(nfa_type)           :: nfa

        type(nfa_type) :: nfa_stack(MAX_STACK)
        integer        :: stack_top        ! no initializer
        type(nfa_type) :: nfa1, nfa2
        integer        :: initial, accept
        integer        :: i, c

        stack_top = 0

        do i = 1, postfix_len
            c = postfix(i)

            if (c == ichar('*')) then
                nfa1      = nfa_stack(stack_top)
                stack_top = stack_top - 1

                initial = new_state()
                accept  = new_state()

                states(initial)%edge1      = nfa1%initial
                states(initial)%edge2      = accept
                states(nfa1%accept)%edge1  = nfa1%initial
                states(nfa1%accept)%edge2  = accept

                stack_top = stack_top + 1
                nfa_stack(stack_top)%initial = initial
                nfa_stack(stack_top)%accept  = accept

            else if (c == ichar('.')) then
                nfa2      = nfa_stack(stack_top) ; stack_top = stack_top - 1
                nfa1      = nfa_stack(stack_top) ; stack_top = stack_top - 1

                states(nfa1%accept)%edge1 = nfa2%initial

                stack_top = stack_top + 1
                nfa_stack(stack_top)%initial = nfa1%initial
                nfa_stack(stack_top)%accept  = nfa2%accept

            else if (c == ichar('|')) then
                nfa2      = nfa_stack(stack_top) ; stack_top = stack_top - 1
                nfa1      = nfa_stack(stack_top) ; stack_top = stack_top - 1

                initial = new_state()
                accept  = new_state()

                states(initial)%edge1      = nfa1%initial
                states(initial)%edge2      = nfa2%initial
                states(nfa1%accept)%edge1  = accept
                states(nfa2%accept)%edge1  = accept

                stack_top = stack_top + 1
                nfa_stack(stack_top)%initial = initial
                nfa_stack(stack_top)%accept  = accept

            else if (c == ichar('+')) then
                nfa1      = nfa_stack(stack_top)
                stack_top = stack_top - 1

                initial = new_state()
                accept  = new_state()

                states(initial)%edge1      = nfa1%initial
                states(nfa1%accept)%edge1  = nfa1%initial
                states(nfa1%accept)%edge2  = accept

                stack_top = stack_top + 1
                nfa_stack(stack_top)%initial = initial
                nfa_stack(stack_top)%accept  = accept

            else if (c == ichar('?')) then
                nfa1      = nfa_stack(stack_top)
                stack_top = stack_top - 1

                initial = new_state()
                accept  = new_state()

                states(initial)%edge1      = nfa1%initial
                states(initial)%edge2      = accept
                states(nfa1%accept)%edge1  = accept

                stack_top = stack_top + 1
                nfa_stack(stack_top)%initial = initial
                nfa_stack(stack_top)%accept  = accept

            else
                initial = new_state(c)
                accept  = new_state()

                states(initial)%edge1 = accept

                stack_top = stack_top + 1
                nfa_stack(stack_top)%initial = initial
                nfa_stack(stack_top)%accept  = accept
            end if
        end do

        nfa = nfa_stack(stack_top)
    end function compile_regex

    function in_set(state_id, set_array, set_size) result(found)
        integer, intent(in) :: state_id
        integer, intent(in) :: set_array(MAX_STATES)
        integer, intent(in) :: set_size
        logical :: found
        integer :: k

        found = .false.
        do k = 1, set_size
            if (set_array(k) == state_id) then
                found = .true.
                return
            end if
        end do
    end function in_set

    subroutine add_to_set(target_set, target_size, source_set, source_size)
        integer, intent(inout) :: target_set(MAX_STATES)
        integer, intent(inout) :: target_size
        integer, intent(in)    :: source_set(MAX_STATES)
        integer, intent(in)    :: source_size
        integer :: k

        do k = 1, source_size
            if (.not. in_set(source_set(k), target_set, target_size)) then
                target_size = target_size + 1
                target_set(target_size) = source_set(k)
            end if
        end do
    end subroutine add_to_set

    function match_regex(pattern, input_string) result(matches)
        character(len=*), intent(in) :: pattern
        character(len=*), intent(in) :: input_string
        logical :: matches

        integer        :: postfix(MAX_POSTFIX)
        integer        :: postfix_len
        type(nfa_type) :: nfa
        integer        :: current_states(MAX_STATES), current_size
        integer        :: next_states(MAX_STATES),    next_size
        integer        :: temp_closure(MAX_STATES),   temp_size
        integer        :: i, j, c

        call shunt(pattern, postfix, postfix_len)
        nfa = compile_regex(postfix, postfix_len)

        call get_epsilon_closure(nfa%initial, current_states, current_size)

        do i = 1, len_trim(input_string)
            c         = ichar(input_string(i:i))
            next_size = 0

            do j = 1, current_size
                if (states(current_states(j))%label == c) then
                    call get_epsilon_closure(states(current_states(j))%edge1, &
                                             temp_closure, temp_size)
                    call add_to_set(next_states, next_size, temp_closure, temp_size)
                end if
            end do

            current_states(1:next_size) = next_states(1:next_size)
            current_size = next_size
        end do

        matches = in_set(nfa%accept, current_states, current_size)
    end function match_regex

end program regex_engine

