! =============================================================================
! stairs.f90  --  Staircase Escape Simulation
! =============================================================================
!
! PROBLEM STATEMENT
! -----------------
! You are trapped at the bottom of a 100-step staircase.  You climb at a rate
! of 1 step per second.  Each second the wizard adds 5 new steps, inserted at
! uniformly random positions anywhere in the staircase.  You escape if you
! ever reach the top (i.e. steps_ahead reaches zero).
!
! KEY INSIGHT -- random insertions
! ---------------------------------
! After you take your step, the staircase has (behind + ahead) steps.  Each
! wizard step is placed uniformly at random in that total length, so:
!
!   P(new step lands behind you) = behind / (behind + ahead)
!   P(new step lands ahead  of you) = ahead  / (behind + ahead)
!
! Early on (behind is small) almost every wizard step lengthens the road
! ahead.  As you progress the odds improve.  The expected fraction of the
! staircase behind you grows as (1/5)*ln(1 + 5t/100), which theoretically
! crosses 1 (i.e. the whole staircase is behind you) around t ~ 2950 s.
!
! PROGRAMME STRUCTURE
! --------------------
! 1. One demo run: simulate until escape (or time cap).
!    Print the state at every second in the window t = 600..609 (10 minutes).
! 2. 10 000 independent trials to obtain escape-time statistics.
! =============================================================================

program stairs
  use iso_fortran_env, only: real64, int64
  implicit none

  ! --------------------------------------------------------------------------
  ! Variable declarations
  ! --------------------------------------------------------------------------

  ! State of the current simulation: number of steps already climbed (behind)
  ! and number of steps still to climb (ahead).
  integer :: behind, ahead

  ! Scratch variables used inside the inner per-second work.
  integer :: total   ! current staircase length = behind + ahead
  integer :: pos     ! random insertion position drawn in [1, total]
  integer :: t       ! elapsed time in seconds (loop counter)
  integer :: k       ! counter for the 5 wizard insertions per second

  ! Multi-trial book-keeping.
  integer :: trial          ! trial number (1..NTRIALS)
  integer :: escaped_count  ! number of trials in which escape was achieved

  ! Accumulators for computing averages; use 64-bit integers to avoid
  ! overflow when summing large escape times across 10 000 trials.
  integer(kind=int64) :: sum_time    ! total seconds across all escaped trials
  integer(kind=int64) :: sum_length  ! total staircase lengths at escape

  ! Floating-point workspace for averages and the random draw.
  real(kind=real64) :: r           ! uniform random number in [0, 1)
  real(kind=real64) :: avg_time    ! mean escape time   over escaped trials
  real(kind=real64) :: avg_length  ! mean staircase length at escape

  ! --------------------------------------------------------------------------
  ! Named constants
  ! --------------------------------------------------------------------------

  ! Safety cap: if a trial has not ended by this many seconds we abandon it
  ! and count it as a non-escape.  10^7 s is far beyond any realistic escape
  ! time (the expected escape is around 3 000 s) so it should never be hit.
  integer, parameter :: MAX_SEC = 10000000

  ! Number of independent trials to run for the statistics section.
  integer, parameter :: NTRIALS = 10000

  ! --------------------------------------------------------------------------
  ! Seed the pseudo-random number generator from the system clock so that
  ! each run of the programme gives different results.
  ! --------------------------------------------------------------------------
  call init_rng()

  ! ==========================================================================
  ! PART 1 -- Single demo run
  ! ==========================================================================

  write(*, '(a)') 'Staircase Escape Simulation'
  write(*, '(a)') '==========================='
  write(*, '(a)') 'Start: 100 steps ahead.  You climb 1 step/s.'
  write(*, '(a)') 'The wizard inserts 5 new steps/s at random positions.'
  write(*, *)

  ! Initialise the staircase: you are at the bottom, all 100 steps lie ahead.
  behind = 0
  ahead  = 100

  ! Print the column header for the t = 600..609 snapshot table.
  write(*, '(a)') 'Snapshot at t = 600 to 609 s (the 10-minute window):'
  write(*, '(a)') '    t       behind        ahead'
  write(*, '(a)') ' ----  ---------  -----------'

  ! ------------------------------------------------------------------
  ! Main simulation loop: one iteration = one second of elapsed time.
  ! ------------------------------------------------------------------
  do t = 1, MAX_SEC

    ! --- Step 1: you climb one step -----------------------------------
    ! Transfer the step immediately in front of you from "ahead" to "behind".
    behind = behind + 1
    ahead  = ahead  - 1

    ! --- Escape check -------------------------------------------------
    ! If ahead is now zero you have reached the top; the simulation ends.
    ! (We do this before inserting wizard steps because the moment you
    ! step onto the final stair you are free -- the wizard cannot add
    ! steps fast enough to stop you at that instant.)
    if (ahead == 0) then
      ! If escape happens to fall inside the 600-609 window, record it
      ! in the table so the row is not left blank.
      if (t >= 600 .and. t <= 609) &
        write(*, '(1x,i4,3x,a)') t, '** ESCAPED **'
      exit   ! leave the do-loop; t retains the escape time
    end if

    ! --- Step 2: wizard inserts 5 new steps ---------------------------
    ! Each of the 5 insertions is handled independently.
    do k = 1, 5

      ! Current total length of the staircase (all steps, wherever they are).
      total = behind + ahead

      ! Draw a uniform random integer in [1, total].
      ! random_number returns r in [0, 1), so:
      !   int(r * total)     is in [0, total-1]
      !   int(r * total) + 1 is in [1, total]
      call random_number(r)
      pos = int(r * total) + 1

      ! If the chosen position is within the section already climbed the new
      ! step ends up behind us (a lucky outcome -- it does not lengthen our
      ! remaining climb).  Otherwise it is inserted ahead and we must climb it.
      if (pos <= behind) then
        behind = behind + 1   ! lucky: new step is behind us
      else
        ahead  = ahead  + 1   ! unlucky: new step adds to the work remaining
      end if

    end do   ! end of 5 wizard insertions

    ! --- Print snapshot for the 10-minute window ----------------------
    ! Report the state at the END of each second in [600, 609], i.e. after
    ! both your climb and the wizard's insertions have been applied.
    if (t >= 600 .and. t <= 609) &
      write(*, '(1x,i4,2i12)') t, behind, ahead

  end do   ! end of main second-by-second loop

  ! If we escaped before the 600 s mark the table will be empty; say why.
  if (t < 600 .and. ahead == 0) &
    write(*, '(a,i0,a)') '(Escaped at t = ', t, ' s, before the 600-609 window.)'

  ! Report the outcome of the single demo run.
  write(*, *)
  if (ahead == 0) then
    write(*, '(a,i0,a)') 'ESCAPED at t = ', t, ' seconds.'
    ! At escape, "behind" equals the total staircase length (ahead = 0).
    write(*, '(a,i0,a)') 'Staircase grew to ', behind, ' steps total.'
  else
    ! This branch should never be reached with MAX_SEC = 10^7, but is kept
    ! as a safeguard in case an extraordinarily unlucky run occurs.
    write(*, '(a)') 'Did not escape within the time limit.'
  end if

  ! ==========================================================================
  ! PART 2 -- 10 000 independent trials to collect statistics
  ! ==========================================================================
  !
  ! We want to know:
  !   (a) how reliably escape can be achieved, and
  !   (b) on average, how long it takes and how large the staircase grows.
  !
  ! Each trial starts fresh (behind=0, ahead=100) with the same rules.
  ! We accumulate the escape time and final staircase length for every trial
  ! that escapes, then divide by the number of successes for the averages.
  ! ==========================================================================

  write(*, *)
  write(*, '(a,i0,a)') 'Running ', NTRIALS, ' independent trials ...'

  ! Zero the counters before the trial loop.
  escaped_count = 0
  sum_time      = 0_int64   ! _int64 literal suffix ensures 64-bit zero
  sum_length    = 0_int64

  do trial = 1, NTRIALS

    ! Reset the staircase for this fresh trial.
    behind = 0
    ahead  = 100

    ! The inner loop is named so that "exit trial_loop" leaves only
    ! this inner loop and does not disturb the outer trial loop.
    trial_loop: do t = 1, MAX_SEC

      ! Climb one step (same logic as the demo run above).
      behind = behind + 1
      ahead  = ahead  - 1

      ! Escape check: if the staircase is exhausted, record and move on.
      if (ahead == 0) exit trial_loop

      ! Wizard inserts 5 steps at random positions.
      do k = 1, 5
        total = behind + ahead
        call random_number(r)
        pos = int(r * total) + 1
        if (pos <= behind) then
          behind = behind + 1
        else
          ahead  = ahead  + 1
        end if
      end do

    end do trial_loop   ! end of seconds loop for this trial

    ! Tally results only for successful escapes.
    ! (If t == MAX_SEC and ahead > 0 the trial timed out; we skip it.)
    if (ahead == 0) then
      escaped_count = escaped_count + 1

      ! Cast to int64 before accumulating to prevent 32-bit overflow.
      ! With NTRIALS=10 000 and typical escape times of ~3 000 s the
      ! sum can reach ~3*10^7, which fits in 32-bit, but for very long
      ! trials it is safer to use 64-bit throughout.
      sum_time   = sum_time   + int(t,      int64)
      sum_length = sum_length + int(behind, int64)
    end if

  end do   ! end of trial loop

  ! --------------------------------------------------------------------------
  ! Print statistics
  ! --------------------------------------------------------------------------
  write(*, *)
  write(*, '(a,i0,a,i0,a)') 'Escaped in ', escaped_count, ' of ', NTRIALS, ' trials.'

  if (escaped_count > 0) then
    ! Divide int64 sums by the (real-converted) count of successes.
    ! Converting both operands to real64 before dividing avoids integer
    ! truncation and gives a meaningful fractional average.
    avg_time   = real(sum_time,   real64) / real(escaped_count, real64)
    avg_length = real(sum_length, real64) / real(escaped_count, real64)

    write(*, '(a,f12.1,a)') 'Average escape time:      ', avg_time,   ' s'
    ! avg_length equals the average total staircase length at the moment
    ! of escape, since at that point behind = total (ahead = 0).
    write(*, '(a,f12.1,a)') 'Average staircase length: ', avg_length, ' steps'
  end if

  ! Warn if any trials hit the safety cap (should not happen in practice).
  if (escaped_count < NTRIALS) &
    write(*, '(a,i0,a)') '(', NTRIALS - escaped_count, ' trial(s) hit the time cap.)'

contains

  ! ==========================================================================
  ! init_rng -- seed the intrinsic pseudo-random number generator
  ! ==========================================================================
  !
  ! Fortran's random_seed / random_number are implementation-defined.  The
  ! default seed is often the same across runs, which would make the demo run
  ! deterministic.  We instead seed every element of the seed array with a
  ! value derived from the system clock, ensuring a different sequence each
  ! time the programme is run.
  !
  ! The multiplier 37 is an arbitrary odd constant that spreads the clock
  ! value across the seed elements; without it, every element would be
  ! identical and some RNG implementations might produce poor sequences.
  ! ==========================================================================
  subroutine init_rng()
    integer :: n        ! number of seed integers required by this compiler
    integer :: i        ! loop index for filling the seed array
    integer :: clock    ! current system-clock tick count
    integer, allocatable :: seed(:)   ! seed array, length determined at runtime

    ! Query how many integers this compiler's RNG needs for its seed.
    call random_seed(size=n)
    allocate(seed(n))

    ! Read the system clock (resolution is implementation-defined, but
    ! typically milliseconds to nanoseconds -- enough for distinct seeds).
    call system_clock(count=clock)

    ! Populate the seed array.  The array constructor [(i, i=1,n)] produces
    ! [1, 2, ..., n], so each seed element gets a unique clock-derived value.
    seed = clock + 37 * [(i, i=1,n)]

    call random_seed(put=seed)
    deallocate(seed)
  end subroutine init_rng

end program stairs

