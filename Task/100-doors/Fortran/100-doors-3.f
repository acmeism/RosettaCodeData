! =============================================================================
! DOORS PROBLEM
! =============================================================================
!
! PROBLEM STATEMENT:
!   100 doors are all initially closed.  We make 100 passes.
!   Pass 1 toggles every door  (1, 2, 3, ..., 100).
!   Pass 2 toggles every 2nd   (2, 4, 6, ..., 100).
!   Pass k toggles every k-th  (k, 2k, 3k, ...).
!   Pass 100 toggles only door 100.
!   What state is each door in after all 100 passes?
!
! ALGORITHM -- DIVISOR COUNTING:
!   Door number D is toggled on pass k if and only if k divides D evenly,
!   i.e. mod(D, k) == 0.  So the total number of toggles that door D receives
!   equals the number of divisors of D (including 1 and D itself).
!
!   Example: door 6
!     Divisors of 6 are 1, 2, 3, 6  =>  4 toggles  =>  even  =>  CLOSED
!
!   Example: door 9
!     Divisors of 9 are 1, 3, 9     =>  3 toggles  =>  odd   =>  OPEN
!
!   A door ends up OPEN  when its divisor count is ODD.
!   A door ends up CLOSED when its divisor count is EVEN.
!
! KEY MATHEMATICAL INSIGHT (why the pattern is perfect squares):
!   Divisors normally come in pairs: if j divides D then (D/j) also divides D,
!   giving an even count.  The only exception is when j == D/j, i.e. j*j == D.
!   That "pairing trick" breaks at the square root, leaving one unpaired divisor
!   and making the total ODD.  This happens exactly when D is a perfect square.
!   So doors 1, 4, 9, 16, 25, 36, 49, 64, 81, 100 are open; all others closed.
!
!   This program proves the result by brute-force divisor counting, rather than
!   assuming the mathematical conclusion up front.
! =============================================================================

program doors
    implicit none

    integer, parameter :: n = 100   ! total number of doors (and passes)
    integer :: door                 ! current door being evaluated (1..n)
    integer :: pass                 ! current pass number being tested (1..n)
    integer :: toggles              ! number of times this door was toggled
    character(6) :: state           ! final state label: 'open' or 'closed'

    ! --- outer loop: consider each door in turn ---
    do door = 1, n

        toggles = 0   ! reset the toggle counter for this door

        ! --- inner loop: check every pass to see if it touches this door ---
        ! Pass number 'pass' visits door 'door' only when 'pass' is a divisor
        ! of 'door'.  mod(door, pass) == 0 means pass divides door exactly.
        do pass = 1, n
            if (mod(door, pass) == 0) toggles = toggles + 1
        end do

        ! --- determine final state from parity of toggle count ---
        ! Starting closed, an odd number of toggles leaves the door open;
        ! an even number returns it to closed.
        if (mod(toggles, 2) == 1) then
            state = 'open'
        else
            state = 'closed'
        end if

        ! --- report result for this door ---
        write(*, '(A, I3, A, A)') 'Door', door, ' is ', trim(state)

    end do

end program doors
