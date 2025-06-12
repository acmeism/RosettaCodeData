program perfect_squares
  implicit none
  integer :: base, i
  integer(8) :: m, m_squared, base_power, start_m
  character(len=:), allocatable :: m_str, square_str
  logical :: found

  do base = 2, 16
    found = .false.
    ! Calculate base^(base-1) for lower bound
    base_power = 1_8
    do i = 1, base-1
      base_power = base_power * int(base, 8)
    end do
    ! Compute start_m as ceiling(sqrt(base_power))
    start_m = int(sqrt(real(base_power, kind=8)), kind=8)
    if (start_m * start_m < base_power) start_m = start_m + 1_8
    ! Search until solution found (no upper limit)
    do m = start_m, huge(1_8)-1
      m_squared = m * m
      square_str = to_base(m_squared, base)
      if (len(square_str) < base) cycle
      if (is_valid_square(square_str, base)) then
        m_str = to_base(m, base)
        print "(A, I2, A, A,T25, A, A)", "Base ", base, " : Num ", trim(m_str), " Square ", trim(square_str)
        found = .true.
        exit
      end if
    end do
    if (.not. found) print *, "No solution for base ", base
  end do
contains
pure function to_base(n, base) result(str)
    integer(8), intent(in) :: n
    integer, intent(in) :: base
    character(len=:), allocatable :: str
    integer(8) :: tmp, bbase, rem
    integer :: i, len
    character(1) :: buffer(32)
    character(1), parameter :: digits(16) = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F']

    tmp = n
    bbase = base
    i = 0
    buffer = ' '   ! Initialize buffer to blanks

    do while (tmp > 0)
        rem = mod(tmp, bbase)
        i = i + 1
        buffer(i) = digits(rem+1)
        tmp = tmp / bbase
    end do

    if (i == 0) then
!        allocate(str(1))
        str(1:1) = '0'
        return
    end if

    allocate(character(i) :: str)
    do len = 1, i
        str(len:len) = buffer(i - len + 1)
    end do
end function to_base

pure function is_valid_square(str, base) result(ok)
    character(len=*), intent(in) :: str
    integer, intent(in) :: base
    logical :: ok
    integer :: i, digit, ascii, seen, mask
    integer, parameter :: char_to_digit(48:70) = [ &
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, & ! '0'–'9'
        ( -1, i = 58, 64 ), &           ! ':'–'@'
        10, 11, 12, 13, 14, 15 ]        ! 'A'–'F'

    if (len(str) < base) then
        ok = .false.
        return
    end if

    seen = 0
    do i = 1, len(str)
        ascii = iachar(str(i:i))
        if (ascii < 48 .or. ascii > 70) then
            ok = .false.
            return
        end if
        digit = char_to_digit(ascii)
        if (digit < 0 .or. digit >= base) then
            ok = .false.
            return
        end if
        seen = ibset(seen, digit)
    end do

    mask = ishft(1, base) - 1
    ok = (seen == mask)
end function is_valid_square

end program perfect_squares
