! last_sundays.f90
!
! Prints the last Sunday of every month for a given year.
! The year is supplied as a command-line argument.
!
! Usage:
!   ./last_sundays <year>
!
! Example:
!   ./last_sundays 2013
!   2013-01-27
!   ...
!
! Algorithm overview:
!   For each month, determine its last calendar day, then use
!   the Tomohiko Sakamoto day-of-week formula to find what
!   weekday that day falls on.  Subtract that offset (0 for
!   Sunday, 1 for Monday, ..., 6 for Saturday) to step back
!   to the nearest Sunday on or before the last day.

program last_sundays
    implicit none

    ! ----------------------------------------------------------------
    ! Variable declarations
    ! ----------------------------------------------------------------
    integer :: year       ! The year supplied by the user
    integer :: month      ! Loop counter: 1 (Jan) .. 12 (Dec)
    integer :: last_day   ! Last calendar day of the current month
    integer :: dow        ! Day-of-week of last_day (0=Sun .. 6=Sat)
    integer :: diff       ! Days to subtract to reach the last Sunday
    integer :: y          ! Year adjusted for the Sakamoto formula

    ! Sakamoto month-offset table.
    ! These constants encode the cumulative day-of-week shift
    ! introduced by each month's length.  January and February are
    ! treated as months 13 and 14 of the *previous* year inside the
    ! formula, which is why the caller decrements y when month < 3.
    integer :: t(12) = [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4]

    ! Days in each month for a normal (non-leap) year.
    ! Element 2 (February) is updated to 29 when the year is a leap year.
    integer :: days(12)

    ! Buffer to receive the raw command-line text for the year
    character(len=20) :: arg

    ! ----------------------------------------------------------------
    ! Read the year from the first command-line argument
    ! ----------------------------------------------------------------
    call get_command_argument(1, arg)   ! Fetch raw text
    read(arg, *) year                   ! Parse it as an integer

    ! ----------------------------------------------------------------
    ! Initialise month lengths for a standard year
    ! ----------------------------------------------------------------
    days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    ! Leap-year rule:
    !   Divisible by 4    -> leap year candidate
    !   Divisible by 100  -> NOT a leap year (century exception)
    !   Divisible by 400  -> IS a leap year (override century rule)
    if ((mod(year,4)==0 .and. mod(year,100)/=0) .or. mod(year,400)==0) &
        days(2) = 29   ! February gets an extra day in a leap year

    ! ----------------------------------------------------------------
    ! Main loop: find the last Sunday of each month
    ! ----------------------------------------------------------------
    do month = 1, 12

        last_day = days(month)   ! Last calendar day of this month

        ! The Sakamoto formula needs the year adjusted so that
        ! January and February belong to the previous year.
        y = year
        if (month < 3) y = y - 1

        ! Tomohiko Sakamoto's day-of-week formula (1993).
        ! Returns 0 for Sunday, 1 for Monday, ..., 6 for Saturday.
        ! The formula combines:
        !   y        - base year contribution
        !   y/4      - one extra day every 4 years (leap years)
        !   -y/100   - remove the century non-leap correction
        !   +y/400   - restore the 400-year leap override
        !   t(month) - month-specific offset from the lookup table
        !   last_day - the actual day number within the month
        ! The whole sum mod 7 gives the weekday.
        dow = mod(y + y/4 - y/100 + y/400 + t(month) + last_day, 7)

        ! 'dow' is already the number of days we must step backwards:
        !   dow=0 -> last_day is already Sunday, subtract 0
        !   dow=1 -> last_day is Monday, subtract 1 to reach Sunday
        !   ...
        !   dow=6 -> last_day is Saturday, subtract 6 to reach Sunday
        diff = dow

        ! Print the result in ISO-8601 format (YYYY-MM-DD)
        write(*, '(I4, "-", I2.2, "-", I2.2)') year, month, last_day - diff

    end do

end program last_sundays
