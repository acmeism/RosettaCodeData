program roulette
  use iso_fortran_env, only: real64
  implicit none

  integer, parameter :: TRIALS = 50000000

  integer  :: scenario, suicides, trial, fp
  logical  :: cylinder(0:5), fired1, fired2
  real(kind=real64) :: pct

  call seed_rng()

  write(*, '(a)') 'Russian Roulette Simulation'
  write(*, '(a)') repeat('=', 58)
  write(*, '(a, i0, a)') 'Trials: ', TRIALS, ' per scenario'
  write(*, '(a)') repeat('-', 58)
  write(*, '(a40, a8, a10)') 'Scenario', 'Result', 'Theory'
  write(*, '(a)') repeat('-', 58)

  do scenario = 1, 4
    suicides = 0

    do trial = 1, TRIALS
      cylinder = .false.
      fp = 0

      ! Load first bullet
      call load(cylinder, fp)

      ! A and B: spin after first bullet
      if (scenario == 1 .or. scenario == 2) call spin(fp)

      ! Load second bullet
      call load(cylinder, fp)

      ! Always spin before first shot
      call spin(fp)

      ! First shot
      fired1 = cylinder(fp)
      fp = mod(fp + 1, 6)

      ! A and C: spin after first shot
      if (scenario == 1 .or. scenario == 3) call spin(fp)

      ! Second shot
      fired2 = cylinder(fp)

      if (fired1 .or. fired2) suicides = suicides + 1
    end do

    pct = 100.0_real64 * real(suicides, real64) / real(TRIALS, real64)

    select case (scenario)
    case (1)
      write(*, '(a40, f7.3, a, a10)') 'A: spin after bullet 1 and after shot 1', pct, '%', '  55.56%'
    case (2)
      write(*, '(a40, f7.3, a, a10)') 'B: spin after bullet 1 only',             pct, '%', '  58.33%'
    case (3)
      write(*, '(a40, f7.3, a, a10)') 'C: spin after shot 1 only',               pct, '%', '  55.56%'
    case (4)
      write(*, '(a40, f7.3, a, a10)') 'D: no extra spins',                        pct, '%', '  50.00%'
    end select
  end do

  write(*, '(a)') repeat('=', 58)
  write(*, '(a)') 'Highest probability of suicide: B'
  write(*, '(a)') 'Answer: B -- spin the cylinder after loading bullet 1 only'

contains

  ! Load one bullet: scan clockwise from fp+1 for an empty chamber,
  ! place bullet there, then advance fp one step clockwise.
  subroutine load(cyl, fp)
    logical, intent(inout) :: cyl(0:5)
    integer, intent(inout) :: fp
    do while (cyl(mod(fp + 1, 6)))
      fp = mod(fp + 1, 6)
    end do
    cyl(mod(fp + 1, 6)) = .true.
    fp = mod(fp + 1, 6)
  end subroutine load

  subroutine spin(fp)
    integer, intent(out) :: fp
    real :: r
    call random_number(r)
    fp = int(r * 6.0)
  end subroutine spin

  subroutine seed_rng()
    integer :: n, clock, i
    integer, allocatable :: seed(:)
    call random_seed(size=n)
    allocate(seed(n))
    call system_clock(count=clock)
    seed = clock + 93 * [(i, i = 1, n)]
    call random_seed(put=seed)
    deallocate(seed)
  end subroutine seed_rng

end program roulette
