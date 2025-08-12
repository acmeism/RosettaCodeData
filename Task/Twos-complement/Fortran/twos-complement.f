!
program twos_complement_demo
  implicit none

  integer :: x, tc
  integer :: nbits
  character(len=:), allocatable :: bits_x, bits_not, bits_tc

  ! Prompt for input
  write(*,"(a)",advance="no")  "Enter a positive integer (or any integer):"
  read  *, x

  ! Determine bit-width and convert to bit-strings
  nbits    = bit_size(x)
  bits_x   = to_bitstring(x)
  bits_not = to_bitstring(not(x))

  ! Compute two's complement: flip all bits then add one
  tc       = not(x) + 1
  bits_tc  = to_bitstring(tc)

  ! Display results
  10 format(a,t30,i0)
  20 format(a,i0,a,t30,a,/)
  30 format(a,t30,a)
  write(*,*)
  write(*,10)  "Original integer:", x
  write(*,20)  "Bit pattern (", nbits, " bits):", trim(bits_x)
  write(*,30)  "After bitwise NOT:        ", trim(bits_not)
  write(*,30)  "Then add 1 --> two’s comp:", trim(bits_tc)
  write(*,*)
  write(*,10)  "Two’s complement (decimal):", tc

contains

  !------------------------------------------------------------
  ! Convert an integer to a string of ‘0’ and ‘1’
  !------------------------------------------------------------
  function to_bitstring(val) result(str)
    integer, intent(in)            :: val
    character(len=:), allocatable  :: str
    integer                        :: n, i

    ! Number of bits in this integer kind
    n = bit_size(val)
    allocate(character(len=n) :: str)

    do i = 1, n
      if (btest(val, n - i)) then
        str(i:i) = '1'
      else
        str(i:i) = '0'
      end if
    end do
  end function to_bitstring

end program twos_complement_demo
