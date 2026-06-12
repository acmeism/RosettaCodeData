! =============================================================================
! selection.f90  --  Simulation of Selection Bias in a Retrospective Study
! =============================================================================
!
! BACKGROUND
! ----------
! In a retrospective observational study, subjects are divided into groups
! AFTER outcomes are known.  This creates selection bias: group membership
! is determined in part by the very outcome being measured.
!
! This simulation replicates a study of COVID-19 over 180 days.  Subjects
! independently accumulate doses of a medication (3, 6, or 9 mg/day), and
! their final group is decided by cumulative dose at the time of COVID
! diagnosis (or at study end if they were never infected).
!
! GROUPS
! ------
!   UNTREATED  cumulative dose = 0 mg  (never started medication)
!   IRREGULAR  0 < dose < 100 mg       (started but not enough)
!   REGULAR    dose >= 100 mg           (substantial medication use)
!
! CRITICAL POINT
! --------------
! Every subject has an IDENTICAL daily COVID risk of 0.1% (p = 0.001).
! The medication has absolutely no effect on that risk.  Any statistical
! difference between groups is PURELY a consequence of the study design:
!
!   * Subjects who get COVID early are frozen into UNTREATED or IRREGULAR
!     (they had no time to accumulate doses), inflating those groups' rates.
!   * Subjects who reach REGULAR status survived the ~67 days needed to
!     accumulate 100 mg without getting COVID -- their remaining risk is
!     therefore lower simply because less study time remains, not because
!     the medication protected them.
!
! This is time-dependent confounding / survivorship bias.
!
! STATISTICS
! ----------
! The Kruskal-Wallis H statistic tests whether the binary outcome (got
! COVID or not) differs significantly across the three groups.  Because the
! outcome is binary, all ties are within two groups (infected / not) and
! the required ranked sums reduce to a closed-form expression, avoiding the
! need to sort 10 000 records.  H > ~10 for 2 d.f. is already significant
! at p < 0.01; values > 50 are overwhelming.
! =============================================================================

program selection_bias
  use iso_fortran_env, only: real64
  implicit none

  ! --------------------------------------------------------------------------
  ! Simulation parameters
  ! --------------------------------------------------------------------------
  integer, parameter :: NSUB  = 10000   ! number of subjects
  integer, parameter :: NDAYS = 180     ! study duration in days
  integer, parameter :: NMON  = 6       ! number of monthly reporting periods
  integer, parameter :: MLEN  = 30      ! days per monthly period

  ! Daily probabilities
  real(kind=real64), parameter :: P_COVID   = 0.001_real64  ! infection risk
  real(kind=real64), parameter :: P_START   = 0.005_real64  ! start meds (naive)
  real(kind=real64), parameter :: P_DOSE    = 0.25_real64   ! take dose (once started)
  !   P_DOSE = 50 * P_START = 0.25; "the chance of continuing was increased 50-fold"

  ! Cumulative dose threshold separating IRREGULAR from REGULAR (mg)
  real(kind=real64), parameter :: THRESHOLD = 100.0_real64

  ! Group codes -- integers kept as named constants for readability
  integer, parameter :: G_UNT = 0   ! UNTREATED
  integer, parameter :: G_IRR = 1   ! IRREGULAR
  integer, parameter :: G_REG = 2   ! REGULAR

  ! --------------------------------------------------------------------------
  ! Per-subject state arrays (indexed 1..NSUB)
  ! --------------------------------------------------------------------------
  logical           :: infected(NSUB)     ! .true. once COVID-19 confirmed
  integer           :: final_grp(NSUB)    ! group at diagnosis or study end
  real(kind=real64) :: cum_dose(NSUB)     ! cumulative medication taken (mg)
  logical           :: med_started(NSUB)  ! .true. once first dose ever taken

  ! --------------------------------------------------------------------------
  ! Monthly reporting arrays  (month m, group g)
  ! mon_start: subjects alive and in group g at the START of month m
  ! mon_covid: new COVID diagnoses in group g DURING month m
  ! --------------------------------------------------------------------------
  integer :: mon_start(NMON, 0:2)
  integer :: mon_covid(NMON, 0:2)

  ! --------------------------------------------------------------------------
  ! Working / summary variables
  ! --------------------------------------------------------------------------
  real(kind=real64) :: r             ! uniform random draw
  integer :: i, day, g, m           ! loop indices
  integer :: ng(0:2), nc(0:2)       ! group sizes and COVID counts (overall)
  real(kind=real64) :: h_stat        ! Kruskal-Wallis H

  ! ==========================================================================
  ! Initialise
  ! ==========================================================================
  call init_rng()

  infected    = .false.
  final_grp   = G_UNT        ! everyone starts UNTREATED
  cum_dose    = 0.0_real64
  med_started = .false.
  mon_start   = 0
  mon_covid   = 0

  ! ==========================================================================
  ! Main simulation -- one outer iteration per day, one inner per subject
  ! ==========================================================================
  do day = 1, NDAYS

    ! Which 30-day reporting period are we in? (1..6)
    m = (day - 1) / MLEN + 1

    ! ------------------------------------------------------------------
    ! Monthly snapshot: count group membership BEFORE this day is
    ! processed, so "N at start of month" reflects who was alive and
    ! uninfected when each reporting period began.
    ! mod(day-1, MLEN)==0 is true for day=1,31,61,91,121,151.
    ! ------------------------------------------------------------------
    if (mod(day - 1, MLEN) == 0) then
      do i = 1, NSUB
        if (.not. infected(i)) then
          g = group_of(cum_dose(i))
          mon_start(m, g) = mon_start(m, g) + 1
        end if
      end do
    end if

    ! ------------------------------------------------------------------
    ! Per-subject daily events
    ! ------------------------------------------------------------------
    do i = 1, NSUB

      if (infected(i)) cycle    ! already diagnosed -- no further changes

      ! ----------------------------------------------------------------
      ! Step 1: COVID infection check.
      ! Done BEFORE the day's medication so that a subject who starts
      ! meds and gets COVID on the same day is still UNTREATED at
      ! the moment of diagnosis (they had not yet taken a dose).
      ! In the historical study, the group is the one the subject was
      ! in "at the time of diagnosis."
      ! ----------------------------------------------------------------
      call random_number(r)
      if (r < P_COVID) then
        infected(i)  = .true.
        final_grp(i) = group_of(cum_dose(i))    ! freeze group now
        mon_covid(m, final_grp(i)) = mon_covid(m, final_grp(i)) + 1
        cycle    ! this subject's journey ends here
      end if

      ! ----------------------------------------------------------------
      ! Step 2: Medication.
      ! Two sub-cases: has this subject ever started taking meds?
      ! ----------------------------------------------------------------
      if (.not. med_started(i)) then

        ! Has never taken meds: small daily chance of starting.
        call random_number(r)
        if (r < P_START) then
          med_started(i) = .true.
          cum_dose(i) = cum_dose(i) + random_dose()   ! first dose today
        end if

      else

        ! Has started: much higher daily probability of taking a dose
        ! (the 50-fold increase: 25% vs 0.5%).  Note they may skip days;
        ! what matters is cumulative total, not daily continuity.
        call random_number(r)
        if (r < P_DOSE) cum_dose(i) = cum_dose(i) + random_dose()

      end if

    end do   ! end subject loop

  end do   ! end day loop

  ! ==========================================================================
  ! Assign final groups to subjects who survived the entire 180-day study.
  ! For infected subjects this was already frozen at diagnosis time above.
  ! ==========================================================================
  do i = 1, NSUB
    if (.not. infected(i)) final_grp(i) = group_of(cum_dose(i))
  end do

  ! Tally overall group sizes and COVID counts.
  ng = 0;  nc = 0
  do i = 1, NSUB
    g = final_grp(i)
    ng(g) = ng(g) + 1
    if (infected(i)) nc(g) = nc(g) + 1
  end do

  ! ==========================================================================
  ! Output -- overall summary table
  ! ==========================================================================
  write(*, '(a)') '=============================================================='
  write(*, '(a)') ' Selection Bias Simulation -- COVID-19 Retrospective Study'
  write(*, '(a)') '=============================================================='
  write(*, '(a,i0,a,i0,a)') ' Subjects : ', NSUB, '     Study duration : ', NDAYS, ' days'
  write(*, '(a,f5.3,a)')    ' Daily COVID risk (ALL subjects) : ', P_COVID*100, ' %'
  write(*, '(a,f5.3,a)')    ' Prob of starting medication     : ', P_START*100, ' % / day'
  write(*, '(a,f5.2,a)')    ' Prob of taking dose once started: ', P_DOSE*100,  ' % / day'
  write(*, '(a,f5.0,a)')    ' Dose threshold (IRREGULAR->REGULAR): ', THRESHOLD, ' mg'
  write(*, '(a)') ' Dose per day (when taken): 3, 6 or 9 mg with equal probability'
  write(*, '(a)') '--------------------------------------------------------------'
  write(*, '(a,t14,a,t22,a,t31,a)') ' Group', 'N', 'COVID', 'Rate (%)'
  write(*, '(a)') ' ----------  -----  -----  --------'
  write(*, '(a,t14,i5,t22,i5,t31,f8.2)') &
      ' UNTREATED', ng(G_UNT), nc(G_UNT), pct(nc(G_UNT), ng(G_UNT))
  write(*, '(a,t14,i5,t22,i5,t31,f8.2)') &
      ' IRREGULAR', ng(G_IRR), nc(G_IRR), pct(nc(G_IRR), ng(G_IRR))
  write(*, '(a,t14,i5,t22,i5,t31,f8.2)') &
      ' REGULAR  ', ng(G_REG), nc(G_REG), pct(nc(G_REG), ng(G_REG))
  write(*, '(a)') ' ----------  -----  -----  --------'
  write(*, '(a,t14,i5,t22,i5,t31,f8.2)') &
      ' TOTAL    ', NSUB, sum(nc), pct(sum(nc), NSUB)

  ! Compute and print the Kruskal-Wallis statistic.
  call kruskal_wallis(final_grp, infected, NSUB, h_stat)
  write(*, *)
  write(*, '(a,f10.3)') ' Kruskal-Wallis H statistic: ', h_stat
  write(*, '(a)') ' (chi-squared distribution, 2 degrees of freedom)'
  write(*, '(a)') ' (H > 10 significant; H > 50 highly significant)'
  write(*, *)
  write(*, '(a)') ' NOTE: every subject had IDENTICAL daily COVID risk (0.1%).'
  write(*, '(a)') ' Group differences reflect selection bias, NOT a treatment effect.'
  write(*, '(a)') ' REGULAR subjects appear protected only because they survived'
  write(*, '(a)') ' long enough to accumulate 100 mg -- leaving them less study time'
  write(*, '(a)') ' in which to acquire COVID.'

  ! ==========================================================================
  ! Output -- monthly breakdown (stretch goal)
  ! ==========================================================================
  !
  ! For each 30-day reporting period:
  !   N  = subjects alive and in that group at the START of the period
  !   C  = new COVID cases within the group DURING that period
  !
  ! Watch how the group distribution shifts over time:
  !   Early months: nearly all subjects are UNTREATED; nearly all COVID
  !                 infections are therefore labelled UNTREATED.
  !   Later months: an increasing fraction has moved into IRREGULAR and
  !                 REGULAR; their COVID counts are correspondingly smaller
  !                 simply because they had fewer days of remaining exposure.
  ! ==========================================================================
  write(*, *)
  write(*, '(a)') '=============================================================='
  write(*, '(a)') ' Monthly Breakdown (N = at risk at start; C = new COVID cases)'
  write(*, '(a)') '=============================================================='
  write(*, '(a)') &
      '  Mon  Days    UNTREATED    IRREGULAR      REGULAR'
  write(*, '(a)') &
      '              (N)    (C)    (N)    (C)    (N)    (C)'
  write(*, '(a)') &
      '  ---  ------  -----  ---   -----  ---   -----  ---'
  do m = 1, NMON
    write(*, '(2x,i2,2x,i3,a,i3,3(2x,i5,i5))') &
        m, MLEN*(m-1)+1, '-', min(MLEN*m, NDAYS), &
        mon_start(m, G_UNT), mon_covid(m, G_UNT), &
        mon_start(m, G_IRR), mon_covid(m, G_IRR), &
        mon_start(m, G_REG), mon_covid(m, G_REG)
  end do

contains

  ! ==========================================================================
  ! group_of -- map cumulative dose to group code
  ! ==========================================================================
  ! Uses 0.5 mg as the "effectively zero" cutoff to guard against any
  ! floating-point residual that might arise from summing many small doses.
  ! ==========================================================================
  pure function group_of(dose) result(g)
    real(kind=real64), intent(in) :: dose
    integer :: g
    if (dose < 0.5_real64) then
      g = G_UNT
    else if (dose < THRESHOLD) then
      g = G_IRR
    else
      g = G_REG
    end if
  end function group_of

  ! ==========================================================================
  ! random_dose -- draw one day's medication amount
  ! ==========================================================================
  ! Returns 3.0, 6.0, or 9.0 mg with equal (1/3) probability each.
  ! Formula: int(r*3)+1 gives 1, 2, or 3; multiply by 3 to get the mg value.
  ! ==========================================================================
  function random_dose() result(d)
    real(kind=real64) :: d, r
    call random_number(r)
    d = real(int(r * 3.0_real64) + 1, real64) * 3.0_real64
  end function random_dose

  ! ==========================================================================
  ! pct -- compute a percentage safely (guards against zero denominator)
  ! ==========================================================================
  pure function pct(num, den) result(p)
    integer, intent(in) :: num, den
    real(kind=real64) :: p
    if (den == 0) then
      p = 0.0_real64
    else
      p = 100.0_real64 * real(num, real64) / real(den, real64)
    end if
  end function pct

  ! ==========================================================================
  ! kruskal_wallis -- H statistic for a binary outcome across 3 groups
  ! ==========================================================================
  !
  ! Standard formula:
  !   H = [12 / (N*(N+1))] * sum_g[ n_g * Rbar_g^2 ]  -  3*(N+1)
  ! where Rbar_g is the mean rank of group g over all N observations.
  !
  ! BINARY OUTCOME SIMPLIFICATION
  ! Because the outcome is binary (infected = 1, not infected = 0), the
  ! N observations split into exactly two tied groups:
  !   n_neg subjects with rank tied at  rneg = (n_neg + 1) / 2
  !   n_pos subjects with rank tied at  rpos = n_neg + (n_pos + 1) / 2
  !
  ! The mean rank for group g follows directly from its COVID count nc_g:
  !   Rbar_g = [(ng_g - nc_g)*rneg + nc_g*rpos] / ng_g
  !
  ! This avoids sorting 10 000 records; only group-level counts are needed.
  !
  ! TIE CORRECTION
  ! H is divided by:  C = 1 - [sum_j(t_j^3 - t_j)] / (N^3 - N)
  ! where t_j is the size of each tied block.  Here j = {neg, pos}.
  ! Corrected H follows chi-squared with k-1 = 2 degrees of freedom.
  ! ==========================================================================
  subroutine kruskal_wallis(grp, inf, n, h)
    integer, intent(in) :: n             ! total number of subjects
    integer, intent(in) :: grp(n)        ! group assignments (0, 1, or 2)
    logical, intent(in) :: inf(n)        ! .true. if subject was infected
    real(kind=real64), intent(out) :: h  ! corrected H statistic

    integer :: i, g
    integer :: ng_kw(0:2), nc_kw(0:2)   ! local group sizes and case counts
    integer :: n_pos, n_neg              ! total infected / not-infected
    real(kind=real64) :: rneg, rpos      ! average rank of each outcome level
    real(kind=real64) :: rbar(0:2)       ! mean rank per group
    real(kind=real64) :: rN              ! N as real for arithmetic
    real(kind=real64) :: h_raw           ! uncorrected H
    real(kind=real64) :: tie_c           ! tie correction factor C

    ! Accumulate group-level counts.
    ng_kw = 0;  nc_kw = 0
    do i = 1, n
      g = grp(i)
      ng_kw(g) = ng_kw(g) + 1
      if (inf(i)) nc_kw(g) = nc_kw(g) + 1
    end do

    n_pos = nc_kw(0) + nc_kw(1) + nc_kw(2)   ! total COVID cases
    n_neg = n - n_pos                           ! total non-cases

    ! Average rank of the not-infected block (ranks 1 .. n_neg).
    rneg = real(n_neg + 1, real64) / 2.0_real64

    ! Average rank of the infected block (ranks n_neg+1 .. n_neg+n_pos).
    rpos = real(n_neg, real64) + real(n_pos + 1, real64) / 2.0_real64

    ! Mean rank for each group from its proportion of COVID cases.
    do g = 0, 2
      if (ng_kw(g) > 0) then
        rbar(g) = ( real(ng_kw(g) - nc_kw(g), real64) * rneg + &
                    real(nc_kw(g),             real64) * rpos ) / &
                  real(ng_kw(g), real64)
      else
        rbar(g) = 0.0_real64
      end if
    end do

    ! Kruskal-Wallis H (uncorrected).
    rN = real(n, real64)
    h_raw = 0.0_real64
    do g = 0, 2
      if (ng_kw(g) > 0) &
        h_raw = h_raw + real(ng_kw(g), real64) * rbar(g)**2
    end do
    h_raw = 12.0_real64 / (rN * (rN + 1.0_real64)) * h_raw &
            - 3.0_real64 * (rN + 1.0_real64)

    ! Tie correction factor.  Casting to real64 before cubing avoids the
    ! integer overflow that would occur for n_neg ~ 10 000 in 32-bit int.
    tie_c = 1.0_real64 - &
        ( real(n_neg, real64)**3 - real(n_neg, real64) + &
          real(n_pos, real64)**3 - real(n_pos, real64) ) / &
        ( rN**3 - rN )

    ! Apply tie correction; fall back to raw H if denominator is zero.
    if (tie_c > 1.0e-10_real64) then
      h = h_raw / tie_c
    else
      h = h_raw
    end if
  end subroutine kruskal_wallis

  ! ==========================================================================
  ! init_rng -- seed the intrinsic RNG from the system clock
  ! ==========================================================================
  ! Without explicit seeding, many compilers use the same default seed,
  ! producing identical results on every run.  Seeding from system_clock
  ! gives a different sequence each time.  The multiplier 37 (an arbitrary
  ! odd constant) spreads the single clock value across all seed elements
  ! so they are not all identical.
  ! ==========================================================================
  subroutine init_rng()
    integer :: sz, i, clock
    integer, allocatable :: seed(:)
    call random_seed(size=sz)
    allocate(seed(sz))
    call system_clock(count=clock)
    seed = clock + 37 * [(i, i=1,sz)]
    call random_seed(put=seed)
    deallocate(seed)
  end subroutine init_rng

end program selection_bias

