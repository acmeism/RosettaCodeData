!==============================================================================
! Dining Philosophers
!   OpenMP threads   = philosophers (the tasks)
!   OpenMP locks     = forks        (the resources)
!
! DEADLOCK PREVENTION -- resource hierarchy (ordered acquisition):
!   The five forks are numbered 1..5. Every philosopher ALWAYS grabs the
!   LOWER-numbered of its two forks first and the higher-numbered one second
!   (min() before max()). Imposing a single global order on how resources are
!   acquired makes a circular wait impossible.
!
!   Deadlock requires all four Coffman conditions to hold simultaneously:
!   mutual exclusion, hold-and-wait, no preemption, and CIRCULAR WAIT.
!   Ordered acquisition breaks circular wait -- there can be no cycle in the
!   "waiting-for" graph when everyone requests forks in the same fixed order --
!   so deadlock cannot occur.
!
!   Concretely this makes exactly one philosopher "left-handed": philosophers
!   1..4 take left-then-right, while Russell (seat 5, whose left fork is 5 and
!   right fork is 1) takes right-then-left. That single asymmetry removes the
!   two symmetric deadlock states (everyone holding their left fork, or
!   everyone holding their right fork).
!
!   All console output is routed through one OpenMP critical region, so the
!   printed trace faithfully reflects the real order of events (concurrent,
!   unsynchronised prints would otherwise interleave and look inconsistent).
!==============================================================================
program dining_philosophers
   use omp_lib
   use iso_fortran_env, only: int64
   implicit none

   integer, parameter :: n = 5          ! philosophers / forks / seats
   integer, parameter :: cycles = 3     ! think-eat cycles per philosopher
   integer(kind=omp_lock_kind) :: forks(n)
   character(len=9), parameter :: names(n) = [character(len=9) :: &
         "Aristotle", "Kant", "Spinoza", "Marx", "Russell"]
   integer :: i

   do i = 1, n
      call omp_init_lock(forks(i))
   end do

   call announce("Dinner is served: 5 philosophers, 5 forks, "// &
                 "lower-numbered fork taken first.")

   !$omp parallel num_threads(n) default(none) shared(forks)
   call philosopher(omp_get_thread_num() + 1, forks, names)
   !$omp end parallel

   do i = 1, n
      call omp_destroy_lock(forks(i))
   end do

   call announce("All philosophers have dined and left. No deadlock occurred.")

contains

   ! One philosopher's lifetime: think, get hungry, acquire both forks in
   ! ascending fork-number order, eat, release, repeat.
   subroutine philosopher(id, forks, names)
      integer, intent(in) :: id
      integer(kind=omp_lock_kind), intent(inout) :: forks(:)
      character(len=*), intent(in) :: names(:)
      integer :: left, right, lo, hi, c

      left  = id
      right = mod(id, n) + 1
      lo    = min(left, right)     ! acquire FIRST  (resource hierarchy)
      hi    = max(left, right)     ! acquire SECOND

      call seed_rng(id)

      do c = 1, cycles
         call announce(trim(names(id))//" is thinking.")
         call random_delay()                       ! thinking: holds no forks

         call announce(trim(names(id))//" is hungry and reaches for forks.")
         call omp_set_lock(forks(lo))              ! lower-numbered fork first
         call omp_set_lock(forks(hi))              ! higher-numbered fork second
         call announce(trim(names(id))//" picked up forks "//itoa(lo)// &
                       " and "//itoa(hi)//" and is eating.")
         call random_delay()                       ! eating: holds both forks

         call omp_unset_lock(forks(hi))
         call omp_unset_lock(forks(lo))
         call announce(trim(names(id))//" put down forks and leaves the room.")
      end do
   end subroutine philosopher

   ! Serialise a line of output so concurrent prints never interleave.
   subroutine announce(msg)
      character(len=*), intent(in) :: msg
      !$omp critical (console)
      print '(a)', msg
      !$omp end critical (console)
   end subroutine announce

   ! Integer -> trimmed string.
   function itoa(v) result(s)
      integer, intent(in) :: v
      character(len=:), allocatable :: s
      character(len=12) :: buf
      write(buf, '(i0)') v
      s = trim(buf)
   end function itoa

   ! Give each philosopher an independent RNG stream.
   subroutine seed_rng(id)
      integer, intent(in) :: id
      integer :: ssize, k
      integer, allocatable :: sd(:)
      integer(int64) :: clk
      call system_clock(clk)
      call random_seed(size=ssize)
      allocate(sd(ssize))
      do k = 1, ssize
         sd(k) = int(mod(clk, 1000000_int64), kind=4) + id*7919 + k*104729
      end do
      call random_seed(put=sd)
   end subroutine seed_rng

   ! Random pause of 100..400 ms (short, so the demo finishes quickly).
   subroutine random_delay()
      real :: r
      integer :: ms
      integer(int64) :: c0, c1, rate
      call random_number(r)
      ms = 100 + int(r * 300.0)
      call system_clock(c0, rate)
      do
         call system_clock(c1)
         if ((c1 - c0) * 1000_int64 / rate >= ms) exit
      end do
   end subroutine random_delay

end program dining_philosophers

