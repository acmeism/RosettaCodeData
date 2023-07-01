program signal_handling
  use, intrinsic :: iso_fortran_env, only: atomic_logical_kind
  implicit none

  interface
    integer(C_INT) function usleep(microseconds) bind(c)
      use, intrinsic :: iso_c_binding, only: C_INT, C_INT32_T
      integer(C_INT32_T), value :: microseconds
    end function usleep
  end interface

  integer, parameter :: half_second = 500000
  integer, parameter :: sigint = 2
  integer, parameter :: sigquit = 3

  logical(atomic_logical_kind) :: interrupt_received[*]
  integer :: half_seconds
  logical :: interrupt_received_ref

  interrupt_received = .false.
  half_seconds = 0

  ! "Install" the same signal handler for both SIGINT and SIGQUIT.
  call signal(sigint, signal_handler)
  call signal(sigquit, signal_handler)

  ! Indefinite loop (until one of the two signals are received).
  do
    if (usleep(half_second) == -1) &
      print *, "Call to usleep interrupted."

    call atomic_ref(interrupt_received_ref, interrupt_received)
    if (interrupt_received_ref) then
      print "(A,I0,A)", "Program ran for ", half_seconds / 2, " second(s)."
      stop
    end if

    half_seconds = half_seconds + 1
    print "(I0)", half_seconds
  end do

contains

  subroutine signal_handler(sig_num)
    use, intrinsic :: iso_c_binding, only: C_INT
    integer(C_INT), value, intent(in) :: sig_num
    ! Must be declared with attribute `value` to force pass-by-value semantics
    ! (what C uses by default).

    select case (sig_num)
      case (sigint)
        print *, "Received SIGINT."
      case (sigquit)
        print *, "Received SIGQUIT."
    end select

    call atomic_define(interrupt_received, .true.)
  end subroutine signal_handler

end program signal_handling
