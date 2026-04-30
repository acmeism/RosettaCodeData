program vampire_numbers
  implicit none
  integer :: count, i, n_digits
  integer(kind=8) :: num, test_nums(3)
!  logical :: is_vampire

  ! Initialize test numbers
  test_nums = [16758243290880_8, 24959017348650_8, 14593825548650_8]

  ! Print first 25 vampire numbers
  print *, 'First 25 vampire numbers and their fangs:'
  count = 0
  num = 1000
  do while (count < 25)
    if (is_vampire(num)) then
      count = count + 1
    end if
    num = num + 1
  end do

  ! Check specific test numbers
  print *, ''
  print *, 'Checking specific numbers:'
  do i = 1, 3
    if (is_vampire(test_nums(i))) then
      continue  ! Output handled in is_vampire
    else
      print *, test_nums(i), ' is not a vampire number.'
    end if
  end do

contains

  logical function is_vampire(num)
    integer(kind=8), intent(in) :: num
    integer(kind=8) :: a, b, start_a, end_a
    integer :: num_digits, half_digits
    character(len=20) :: num_str, a_str, b_str

    ! Get number of digits
    num_digits = floor(log10(real(num))) + 1
    if (mod(num_digits, 2) /= 0) then
      is_vampire = .false.
      return
    end if
    half_digits = num_digits / 2

    ! Calculate range for factor a
    start_a = max(10**(half_digits-1), num / (10**half_digits))
    end_a = min(num / 10**(half_digits-1), floor(sqrt(real(num))))

    is_vampire = .false.
    do a = start_a, end_a
      if (mod(num, a) /= 0) cycle
      b = num / a

      ! Check if b has correct number of digits
      if (b < 10**(half_digits-1) .or. b >= 10**half_digits) cycle

      ! Check trailing zeros
      if (mod(a, 10_8) == 0 .and. mod(b, 10_8) == 0) cycle

      ! Check if digits match
      write(num_str, '(I0)') num
      write(a_str, '(I0)') a
      write(b_str, '(I0)') b
      if (len_trim(a_str) == half_digits .and. len_trim(b_str) == half_digits) then
        if (same_digits(num_str, a_str, b_str)) then
          is_vampire = .true.
          print '(I0, " : (", I0, ", ", I0, ")")', num, a, b
        end if
      end if
    end do
  end function is_vampire

  logical function same_digits(num_str, a_str, b_str)
    character(len=*), intent(in) :: num_str, a_str, b_str
    integer :: digits_num(0:9), digits_ab(0:9), i
    character(len=1) :: c

    digits_num = 0
    digits_ab = 0

    ! Count digits in num
    do i = 1, len_trim(num_str)
      read(num_str(i:i), '(A)') c
      digits_num(ichar(c) - ichar('0')) = digits_num(ichar(c) - ichar('0')) + 1
    end do

    ! Count digits in a
    do i = 1, len_trim(a_str)
      read(a_str(i:i), '(A)') c
      digits_ab(ichar(c) - ichar('0')) = digits_ab(ichar(c) - ichar('0')) + 1
    end do

    ! Count digits in b
    do i = 1, len_trim(b_str)
      read(b_str(i:i), '(A)') c
      digits_ab(ichar(c) - ichar('0')) = digits_ab(ichar(c) - ichar('0')) + 1
    end do

    same_digits = all(digits_num == digits_ab)
  end function same_digits

end program vampire_numbers
