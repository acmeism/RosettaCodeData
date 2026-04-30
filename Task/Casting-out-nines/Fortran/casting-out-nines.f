program main
    implicit none

    type :: test_case
        integer :: base
        character(len=10) :: begin, end_
        character(len=10), dimension(5) :: kaprekar
        integer :: nkap
    end type test_case

    type(test_case), dimension(2) :: testcases
    type(test_case) :: tc
    integer :: it, i, j
    character(len=20), allocatable :: s(:)
    logical :: found

    ! Initialize test cases
    testcases(1)%base = 10
    testcases(1)%begin = '1'
    testcases(1)%end_ = '100'
    testcases(1)%kaprekar(1:5) = (/'1  ', '9  ', '45 ', '55 ', '99 '/)
    testcases(1)%nkap = 5

    testcases(2)%base = 17
    testcases(2)%begin = '10'
    testcases(2)%end_ = 'gg'
    testcases(2)%kaprekar(1:3) = (/'3d', 'd4', 'gg'/)
    testcases(2)%nkap = 3

    do it = 1, 2
        tc = testcases(it)
        write(*, *) ''
        write(*, '(A, I0, A, A, A, A)') 'Test case base = ', tc%base, ', begin = ', trim(tc%begin), ', end = ', trim(tc%end_)
        call subset(tc%base, tc%begin, tc%end_, s)
        write(*, '(A)', advance='no') 'Subset:   '
        do i = 1, size(s)
            write(*, '(A, A)', advance='no') trim(s(i)), ' '
        end do
        write(*, *)
        write(*, '(A)', advance='no') 'Kaprekar: '
        do i = 1, tc%nkap
            write(*, '(A, A)', advance='no') trim(tc%kaprekar(i)), ' '
        end do
        write(*, *)

        ! Check if all Kaprekar are in subset
        j = 1
        do i = 1, tc%nkap
            found = .false.
            do while (j <= size(s))
                if (trim(s(j)) == trim(tc%kaprekar(i))) then
                    found = .true.
                    j = j + 1
                    exit
                end if
                j = j + 1
            end do
            if (.not. found) then
                write(*, '(A, A, A)') 'Fail: ', trim(tc%kaprekar(i)), ' not in subset'
                stop
            end if
        end do
        write(*, *) 'Valid subset.'
        if (allocated(s)) deallocate(s)
    end do

contains

    subroutine subset(base, begin, end_, s)
        integer, intent(in) :: base
        character(len=*), intent(in) :: begin, end_
        character(len=20), allocatable, intent(out) :: s(:)
        integer(8) :: begin64, end64, k, kk
        character(len=20) :: ks, kks
        character(1) :: rk, rk2

        begin64 = str_to_int(base, begin)
        end64 = str_to_int(base, end_)

        allocate(s(0))  ! Start empty

        do k = begin64, end64
            ks = int_to_str(base, k)
            rk = check_digit(base, ks)
            kk = k * k
            kks = int_to_str(base, kk)
            rk2 = check_digit(base, kks)
            if (rk == rk2) then
                call append_str(s, ks)
            end if
        end do
    end subroutine subset

    subroutine append_str(list, val)
        character(len=20), allocatable, intent(inout) :: list(:)
        character(len=*), intent(in) :: val
        character(len=20), allocatable :: tmp(:)

        if (allocated(list)) then
            allocate(tmp(size(list)))
            tmp = list
            deallocate(list)
            allocate(list(size(tmp) + 1))
            list(1:size(tmp)) = tmp
            list(size(tmp) + 1) = val
        else
            allocate(list(1))
            list(1) = val
        end if
    end subroutine append_str

    recursive function check_digit(base, n) result(r)
        integer, intent(in) :: base
        character(len=*), intent(in) :: n
        character(1) :: r
        character(1) :: d, b9
        character(len=20) :: s, s9
        integer :: i, v9

        v9 = base - 1
        s9 = int_to_str(base, int(v9, 8))
        b9 = s9(1:1)  ! Single digit

        r = '0'
        do i = 1, len_trim(n)
            d = n(i:i)
            if (d == b9) cycle
            if (r == '0') then
                r = d
                cycle
            end if
            s = add_digits(base, r, d)
            if (trim(s) == trim(s9)) then
                r = '0'
                cycle
            end if
            if (len_trim(s) == 1) then
                r = s(1:1)
                cycle
            end if
            ! Recurse on two-digit sum
            r = check_digit(base, trim(s))
        end do
    end function check_digit

    function add_digits(base, a, b) result(res)
        integer, intent(in) :: base
        character(1), intent(in) :: a, b
        character(len=20) :: res
        integer :: ai, bi

        ai = digit_value(a, base)
        bi = digit_value(b, base)
        res = int_to_str(base, int(ai + bi, 8))
    end function add_digits

    function digit_value(c, base) result(v)
        character(1), intent(in) :: c
        integer, intent(in) :: base
        integer :: v

        if (c >= '0' .and. c <= '9') then
            v = iachar(c) - iachar('0')
        else if (c >= 'a' .and. c <= 'z') then
            v = 10 + iachar(c) - iachar('a')
        else
            stop 'invalid digit'
        end if
        if (v < 0 .or. v >= base) stop 'invalid digit for base'
    end function digit_value

    function value_to_digit(v) result(c)
        integer, intent(in) :: v
        character(1) :: c

        if (v < 10) then
            c = achar(iachar('0') + v)
        else
            c = achar(iachar('a') + v - 10)
        end if
    end function value_to_digit

    function int_to_str(base, k) result(s)
        integer, intent(in) :: base
        integer(8), intent(in) :: k
        character(len=20) :: s
        integer(8) :: kk
        integer :: digit

        kk = k
        if (kk < 0) kk = -kk  ! But not handling negatives in this context
        s = ''
        if (kk == 0) then
            s = '0'
            return
        end if
        do while (kk > 0)
            digit = mod(kk, int(base, 8))
            s = value_to_digit(digit) // s
            kk = kk / int(base, 8)
        end do
    end function int_to_str

    function str_to_int(base, s) result(val)
        integer, intent(in) :: base
        character(len=*), intent(in) :: s
        integer(8) :: val
        integer :: i, lens, v
        character(len=20) :: ss

        ss = adjustl(s)
        lens = len_trim(ss)
        val = 0
        do i = 1, lens
            v = digit_value(ss(i:i), base)
            val = val * int(base, 8) + int(v, 8)
        end do
    end function str_to_int

end program main
