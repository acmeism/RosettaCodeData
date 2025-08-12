program parse_ip_address
    implicit none

    ! Parameters
    integer, parameter :: MAX_TESTS = 10
    integer, parameter :: MAX_STR_LEN = 100
    integer, parameter :: MAX_HEX_LEN = 32

    ! Variables
    character(len=MAX_STR_LEN), dimension(MAX_TESTS) :: test_cases
    character(len=MAX_HEX_LEN) :: hex_address
    character(len=10) :: port_str
    integer :: i, status

    ! Initialize test cases
    test_cases(1) = '192.168.0.1'
    test_cases(2) = '127.0.0.1'
    test_cases(3) = '256.0.0.1'
    test_cases(4) = '127.0.0.1:80'
    test_cases(5) = '::1'
    test_cases(6) = '[::1]:80'
    test_cases(7) = '[32e::12f]:80'
    test_cases(8) = '2605:2700:0:3::4713:93e3'
    test_cases(9) = '[2605:2700:0:3::4713:93e3]:80'
    test_cases(10) = '2001:db8:85a3:0:0:8a2e:370:7334'

    ! Print header
    write(*,'(A40,1X,A32,3X,A)') 'Test Case', 'Hex Address', 'Port'
    write(*,'(A40,1X,A32,3X,A)') repeat('-',40), repeat('-',32), repeat('-',4)

    ! Process each test case
    do i = 1, MAX_TESTS
        call parse_ip(trim(test_cases(i)), hex_address, port_str, status)
        if (status == 0) then
            write(*,'(A40,1X,A32,3X,A)') trim(test_cases(i)), trim(hex_address), trim(port_str)
        else
            write(*,'(A40,1X,A)') trim(test_cases(i)), 'Invalid address'
        end if
    end do

end program parse_ip_address

! Main parsing subroutine
subroutine parse_ip(ip_str, hex_address, port_str, status)
    implicit none
    character(len=*), intent(in) :: ip_str
    character(len=*), intent(out) :: hex_address, port_str
    integer, intent(out) :: status

    ! Try IPv4 first
    call parse_ipv4(ip_str, hex_address, port_str, status)
    if (status == 0) return

    ! Try IPv6
    call parse_ipv6(ip_str, hex_address, port_str, status)
    if (status == 0) return

    ! If neither worked, return error
    status = -1

end subroutine parse_ip

! Parse IPv4 address
subroutine parse_ipv4(ip_str, hex_address, port_str, status)
    implicit none
    character(len=*), intent(in) :: ip_str
    character(len=*), intent(out) :: hex_address, port_str
    integer, intent(out) :: status

    character(len=100) :: work_str
    integer :: dot_pos(3), colon_pos
    integer :: octets(4)
    integer :: i, start_pos, end_pos, port_val
    character(len=2) :: hex_part

    work_str = trim(ip_str)
    hex_address = ''
    port_str = ''
    status = 0

    ! Find colon for port (if present)
    colon_pos = index(work_str, ':', .true.)  ! Find last colon
    if (colon_pos > 0) then
        ! Extract port
        read(work_str(colon_pos+1:), *, iostat=status) port_val
        if (status /= 0) then
            status = -1
            return
        end if
        write(port_str, '(I0)') port_val
        work_str = work_str(1:colon_pos-1)
    end if

    ! Find dots
    dot_pos(1) = index(work_str, '.')
    if (dot_pos(1) == 0) then
        status = -1
        return
    end if

    dot_pos(2) = index(work_str(dot_pos(1)+1:), '.') + dot_pos(1)
    if (dot_pos(2) == dot_pos(1)) then
        status = -1
        return
    end if

    dot_pos(3) = index(work_str(dot_pos(2)+1:), '.') + dot_pos(2)
    if (dot_pos(3) == dot_pos(2)) then
        status = -1
        return
    end if

    ! Parse octets
    read(work_str(1:dot_pos(1)-1), *, iostat=status) octets(1)
    if (status /= 0 .or. octets(1) < 0 .or. octets(1) > 255) then
        status = -1
        return
    end if

    read(work_str(dot_pos(1)+1:dot_pos(2)-1), *, iostat=status) octets(2)
    if (status /= 0 .or. octets(2) < 0 .or. octets(2) > 255) then
        status = -1
        return
    end if

    read(work_str(dot_pos(2)+1:dot_pos(3)-1), *, iostat=status) octets(3)
    if (status /= 0 .or. octets(3) < 0 .or. octets(3) > 255) then
        status = -1
        return
    end if

    read(work_str(dot_pos(3)+1:), *, iostat=status) octets(4)
    if (status /= 0 .or. octets(4) < 0 .or. octets(4) > 255) then
        status = -1
        return
    end if

    ! Convert to hex
    do i = 1, 4
        call int_to_hex2(octets(i), hex_part)
        hex_address = trim(hex_address) // hex_part
    end do

    status = 0

end subroutine parse_ipv4

! Parse IPv6 address (simplified version)
subroutine parse_ipv6(ip_str, hex_address, port_str, status)
    implicit none
    character(len=*), intent(in) :: ip_str
    character(len=*), intent(out) :: hex_address, port_str
    integer, intent(out) :: status

    character(len=100) :: work_str, expanded_str
    integer :: bracket_start, bracket_end, colon_pos
    integer :: port_val

    work_str = trim(ip_str)
    hex_address = ''
    port_str = ''
    status = 0

    ! Handle bracketed IPv6 with port
    bracket_start = index(work_str, '[')
    bracket_end = index(work_str, ']')

    if (bracket_start > 0 .and. bracket_end > bracket_start) then
        ! Extract IPv6 part
        work_str = work_str(bracket_start+1:bracket_end-1)

        ! Check for port after bracket
        colon_pos = index(ip_str(bracket_end+1:), ':')
        if (colon_pos > 0) then
            read(ip_str(bracket_end+colon_pos+1:), *, iostat=status) port_val
            if (status /= 0) then
                status = -1
                return
            end if
            write(port_str, '(I0)') port_val
        end if
    end if

    ! Expand double colon if present
    call expand_ipv6(work_str, expanded_str, status)
    if (status /= 0) return

    ! Convert expanded IPv6 to hex
    call ipv6_to_hex(expanded_str, hex_address, status)

end subroutine parse_ipv6

! Expand IPv6 double colon notation
subroutine expand_ipv6(ipv6_str, expanded_str, status)
    implicit none
    character(len=*), intent(in) :: ipv6_str
    character(len=*), intent(out) :: expanded_str
    integer, intent(out) :: status

    character(len=100) :: work_str
    integer :: double_colon_pos, colon_count, zeros_needed
    integer :: i, pos

    work_str = trim(ipv6_str)
    expanded_str = ''
    status = 0

    ! Find double colon
    double_colon_pos = index(work_str, '::')

    if (double_colon_pos == 0) then
        ! No double colon, just copy
        expanded_str = work_str
        return
    end if

    ! Count existing colons (excluding the double colon)
    colon_count = 0
    do i = 1, len_trim(work_str)
        if (work_str(i:i) == ':') colon_count = colon_count + 1
    end do
    colon_count = colon_count - 2  ! Subtract the double colon

    ! Calculate zeros needed
    zeros_needed = 8 - colon_count - 1
    if (double_colon_pos == 1) zeros_needed = zeros_needed + 1
    if (double_colon_pos == len_trim(work_str)-1) zeros_needed = zeros_needed + 1

    ! Build expanded string
    if (double_colon_pos == 1) then
        expanded_str = '0'
        do i = 1, zeros_needed - 1
            expanded_str = trim(expanded_str) // ':0'
        end do
        if (len_trim(work_str) > 2) then
            expanded_str = trim(expanded_str) // work_str(3:)
        end if
    else if (double_colon_pos == len_trim(work_str)-1) then
        expanded_str = work_str(1:double_colon_pos-1)
        do i = 1, zeros_needed
            expanded_str = trim(expanded_str) // ':0'
        end do
    else
        expanded_str = work_str(1:double_colon_pos-1)
        do i = 1, zeros_needed
            expanded_str = trim(expanded_str) // ':0'
        end do
        expanded_str = trim(expanded_str) // work_str(double_colon_pos+2:)
    end if

end subroutine expand_ipv6

! Convert expanded IPv6 to hex
subroutine ipv6_to_hex(ipv6_str, hex_address, status)
    implicit none
    character(len=*), intent(in) :: ipv6_str
    character(len=*), intent(out) :: hex_address
    integer, intent(out) :: status

    character(len=100) :: work_str
    character(len=10) :: segment
    character(len=4) :: hex_segment
    integer :: colon_pos, start_pos, i

    work_str = trim(ipv6_str) // ':'  ! Add trailing colon for easier parsing
    hex_address = ''
    start_pos = 1
    status = 0

    do i = 1, 8
        colon_pos = index(work_str(start_pos:), ':')
        if (colon_pos == 0) then
            status = -1
            return
        end if
        colon_pos = colon_pos + start_pos - 1

        segment = work_str(start_pos:colon_pos-1)
        if (len_trim(segment) == 0) segment = '0'

        ! Pad to 4 hex digits
        write(hex_segment, '(A4)') segment
        call pad_hex(hex_segment)
        hex_address = trim(hex_address) // hex_segment

        start_pos = colon_pos + 1
    end do

end subroutine ipv6_to_hex

! Convert integer to 2-digit hex
subroutine int_to_hex2(val, hex_str)
    implicit none
    integer, intent(in) :: val
    character(len=2), intent(out) :: hex_str

    character(len=16), parameter :: hex_digits = '0123456789abcdef'

    hex_str(1:1) = hex_digits(val/16 + 1:val/16 + 1)
    hex_str(2:2) = hex_digits(mod(val,16) + 1:mod(val,16) + 1)

end subroutine int_to_hex2

! Pad hex string with leading zeros
subroutine pad_hex(hex_str)
    implicit none
    character(len=4), intent(inout) :: hex_str

    integer :: i, j
    character(len=4) :: temp_str

    ! Remove leading spaces and pad with zeros
    temp_str = adjustl(hex_str)
    hex_str = '0000'
    j = 4 - len_trim(temp_str) + 1
    if (j <= 4) then
        hex_str(j:4) = trim(temp_str)
    end if

end subroutine pad_hex
