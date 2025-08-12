program calendar_converter
    implicit none

    character(len=40) :: input_date,tstring
    integer :: year, month, day, jd, i
    logical :: is_gregorian
!
    ! Test date arrays
    character(len=*), parameter :: rep_dates(5) = [ &
        '1 Vendemiaire 1           ', &
        '1 Prairial 3              ', &
        '27 Messidor 7             ', &
        'Fete de la Revolution 11  ', &
        '10 Nivose 14              ' ]

    character(len=*), parameter :: greg_dates(5) = [ &
        '22 September 1792         ', &
        '20 May 1795               ', &
        '15 July 1799              ', &
        '23 September 1803         ', &
        '31 December 1805          ' ]
    do
        print *, "Enter date (format examples):"
        print *, "Gregorian: '20 May 1795' or Republican: '1 Prairial 3'"
        print *, "Press Enter to exit"
        read (*, '(a)') input_date
        input_date = to_lower(input_date)

        if (len_trim(input_date) == 0) exit

        ! Try parsing as Gregorian first
        if (parse_gregorian(input_date, year, month, day)) then
            is_gregorian = .true.
        else if (parse_republican(input_date, year, month, day)) then
            is_gregorian = .false.
        else
            print *, "Invalid date format"
            cycle
        end if

        if (is_gregorian) then
            jd = gregorian_to_jd(year, month, day)
            call jd_to_republican(jd, year, month, day)
            print *, "Republican date: ", republican_date_string(year, month, day)
        else
            jd = republican_to_jd(year, month, day)
            call jd_to_gregorian(jd, year, month, day)
            print *, "Gregorian date: ", gregorian_date_string(year, month, day)
        end if
    end do


    ! Automatic conversions when exiting
    print *, 'Converting predefined Republican dates:'
    do i = 1, size(rep_dates)
        tstring = to_lower(rep_dates(i))
        if (parse_republican(trim(tstring), year, month, day)) then
            jd = republican_to_jd(year, month, day)
            call jd_to_gregorian(jd, year, month, day)
            print *, rep_dates(i), ' => ', gregorian_date_string(year, month, day)
        end if
    end do

    print '(/,a)','Converting predefined Gregorian dates:'
    do i = 1, size(greg_dates)
        tstring = to_lower(greg_dates(i))
        if (parse_gregorian(trim(tstring), year, month, day)) then
            jd = gregorian_to_jd(year, month, day)
            call jd_to_republican(jd, year, month, day)
            print *, greg_dates(i), ' => ', republican_date_string(year, month, day)
        end if
    end do

contains

    function parse_gregorian(str, y, m, d) result(success)
        character(*), intent(in) :: str
        integer, intent(out) :: y, m, d
        logical :: success
        character(len=3) :: mon
        integer :: ios

        read(str, *, iostat=ios) d, mon, y
        if (ios == 0) then
            m = month_number(mon)
            success = (m > 0)
        else
            success = .false.
        end if
    end function parse_gregorian

    function parse_republican(str, y, m, d) result(success)
        character(*), intent(in) :: str
        integer, intent(out) :: y, m, d
        logical :: success
        character(len=35) :: tokens(10)
        integer :: num_tokens, i, ios
        character(len=100) :: festival_name

        success = .false.
        tokens = ' '
        call tokenize(str, tokens, num_tokens)

        if (num_tokens < 2) return

        if (.not. is_numeric(tokens(num_tokens))) return
        read(tokens(num_tokens), *, iostat=ios) y
        if (ios /= 0) return

        if (num_tokens == 3) then
            if (.not. is_numeric(tokens(1))) return
            read(tokens(1), *, iostat=ios) d
            if (ios /= 0) return

            do m = 1, 12
                if (trim(tokens(2)) == republican_months(m)) then
                    success = .true.
                    return
                end if
            end do
        else if (num_tokens >= 4) then
            if (tokens(1) /= 'fete') return

            festival_name = tokens(1)
            do i = 2, num_tokens-1
                festival_name = festival_name(1:len_trim(festival_name)) // ' ' // tokens(i)
            end do
            do i = 1, 6
                if (festival_name == sansculottides(i)) then
                    m = 13
                    d = i
                    success = .true.
                    return
                end if
            end do
        end if
    end function parse_republican

    function to_lower(str) result(lower_str)
        character(*), intent(in) :: str
        character(len(str)) :: lower_str
        integer :: i, c
        lower_str = str
        do i = 1, len(str)
            c = iachar(str(i:i))
            if (c >= 65 .and. c <= 90) lower_str(i:i) = achar(c + 32)
        end do
    end function to_lower

    subroutine tokenize(input_string, tokens, num_tokens)
        character(*), intent(in) :: input_string
        character(*), intent(out) :: tokens(:)
        integer, intent(out) :: num_tokens
        integer :: i, start_idx, end_idx, str_len
        character(len=len(input_string)) :: temp_str

        num_tokens = 0
        temp_str = adjustl(input_string)
        str_len = len_trim(temp_str)
        if (str_len == 0) return

        start_idx = 1
        do i = 1, str_len
            if (scan(temp_str(i:i), " -/,.") > 0) then
                end_idx = i - 1
                if (end_idx >= start_idx) then
                    num_tokens = num_tokens + 1
                    if (num_tokens > size(tokens)) exit
                    tokens(num_tokens) = temp_str(start_idx:end_idx)
                end if
                start_idx = i + 1
            end if
        end do

        if (start_idx <= str_len) then
            num_tokens = num_tokens + 1
            if (num_tokens <= size(tokens)) then
                tokens(num_tokens) = temp_str(start_idx:)
            end if
        end if
    end subroutine tokenize

    function is_numeric(str) result(res)
        character(*), intent(in) :: str
        logical :: res
        integer :: ios
        integer :: dummy
        read(str, *, iostat=ios) dummy
        res = (ios == 0)
    end function is_numeric

    function republican_months(m) result(namer)
        integer, intent(in) :: m
        character(len=12) :: namer
        character(len=12), parameter :: names(13) = [character(len=12):: &
            'vendemiaire ', 'brumaire   ', 'frimaire   ', 'nivose     ', &
            'pluviose   ', 'ventose    ', 'germinal   ', 'floreal    ', &
            'prairial   ', 'messidor   ', 'thermidor  ', 'fructidor  ', &
            'sansculott' ]
        namer = names(m)
    end function republican_months

    function sansculottides(d) result(name)
        integer, intent(in) :: d
        character(len=21) :: name
        character(len=21), parameter :: names(6) = [ character(len=21)::&
            'fete de la vertu    ', 'fete du genie       ', &
            'fete du travail     ', 'fete de l''opinion   ', &
            'fete des recompenses', 'fete de la revolution' ]
        name = names(d)
    end function sansculottides

    function gregorian_date_string(y, m, d) result(str)
        integer, intent(in) :: y, m, d
        character(len=21) :: str
        write(str, '(i0, 1x, a, 1x, i0)') d, trim(gregorian_months(m)), y
    end function gregorian_date_string

    function republican_date_string(y, m, d) result(str)
        integer, intent(in) :: y, m, d
        character(len=30) :: str
        character(len=30) :: holder
        if (m == 13) then
            holder = uppercasefirst(trim(sansculottides(d)))
            write(str, '(a, 1x, i0)') trim(holder), y
        else
            holder = uppercasefirst(trim(republican_months(m)))
            write(str, '(i0, 1x, a, 1x, i0)') d, trim(holder), y
        end if
    end function republican_date_string

    function month_number(mon) result(m)
        character(*), intent(in) :: mon
        integer :: m
        character(len=3) :: months(12) = ['jan','feb','mar','apr','may','jun', &
                                          'jul','aug','sep','oct','nov','dec']
        do m = 1, 12
            if (months(m) == mon) return
        end do
        m = 0
    end function month_number

    function gregorian_months(m) result(name)
        integer, intent(in) :: m
        character(len=3) :: name
        character(len=3) :: names(12) = ['Jan','Feb','Mar','Apr','May','Jun', &
                                         'Jul','Aug','Sep','Oct','Nov','Dec']
        name = names(m)
    end function gregorian_months

    function republican_to_jd(year, month, day) result(jd)
        integer, intent(in) :: year, month, day
        integer :: jd
        integer, parameter :: epoch_jd = 2375840
        integer :: total_days, leap_years, y

        if (month < 1 .or. month > 13) error stop "Invalid Republican month"
        if (day < 1 .or. (month < 13 .and. day > 30)) error stop "Invalid Republican day"
        if (month == 13 .and. day > 6) error stop "Invalid Sansculottides day"

        total_days = (year - 1) * 365 + (month - 1) * 30 + (day - 1)
        leap_years = count([(is_republican_leap(y), y = 1, year-1)])
        total_days = total_days + leap_years
        jd = epoch_jd + total_days
    end function republican_to_jd

    integer function gregorian_to_jd(year, month, day)
        integer, intent(in) :: year, month, day
        integer :: a, y, m
        a = (14 - month) / 12
        y = year + 4800 - a
        m = month + 12*a - 3
        gregorian_to_jd = day + ((153*m + 2)/5) + 365*y + y/4 - y/100 + y/400 - 32045
    end function gregorian_to_jd

    pure logical function is_republican_leap(y)
        integer, intent(in) :: y
        integer, parameter :: historical_leaps(*) = [3, 7, 11, 15, 20]
        is_republican_leap = any(historical_leaps == y)
    end function is_republican_leap

    subroutine jd_to_gregorian(jd, year, month, day)
        integer, intent(in) :: jd
        integer, intent(out) :: year, month, day
        integer :: a, b, c, d, e, m
        a = jd + 32044
        b = (4*a + 3)/146097
        c = a - (146097*b)/4
        d = (4*c + 3)/1461
        e = c - (1461*d)/4
        m = (5*e + 2)/153
        day = int(e - (153*m + 2)/5 + 1)
        month = int(m + 3 - 12*(m/10))
        year = int(100*b + d - 4800 + (m/10))
    end subroutine jd_to_gregorian

    subroutine jd_to_republican(jd, year, month, day)
        integer, intent(out) :: year, month, day
        integer, intent(in) :: jd
        integer, parameter :: epoch_jd = 2375840
        integer :: days_since_epoch, y, leap_days, d

        days_since_epoch = jd - epoch_jd
        if (days_since_epoch < 0) error stop "Date before Republican epoch"

        year = 1 + days_since_epoch / 365
        leap_days = count([(is_republican_leap(y), y = 1, year-1)])

        d = days_since_epoch - (year-1)*365 - leap_days
        if (d < 0) then
            year = year - 1
            leap_days = count([(is_republican_leap(y), y = 1, year-1)])
            d = days_since_epoch - (year-1)*365 - leap_days
        end if

        if (d < 360) then
            month = d/30 + 1
            day = mod(d,30) + 1
        else
            month = 13
            day = d - 359
        end if
    end subroutine jd_to_republican

    function uppercasefirst(str) result(result_str)
        character(len=*), intent(in) :: str
        character(len=len(str)) :: result_str
        integer :: c
        result_str = str
        if (len_trim(str) > 0) then
            c = iachar(str(1:1))
            if (c >= iachar('a') .and. c <= iachar('z')) then
                result_str(1:1) = achar(c - 32)
            end if
        end if
    end function uppercasefirst

end program calendar_converter
