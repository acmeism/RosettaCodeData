module Miller_Rabin
  use PrimeDecompose
  implicit none

  integer, parameter :: max_decompose = 100

  private :: int_rrand, max_decompose

contains

  function int_rrand(from, to)
    integer(huge) :: int_rrand
    integer(huge), intent(in) :: from, to

    real :: o
    call random_number(o)
    int_rrand = floor(from + o * real(max(from,to) - min(from, to)))
  end function int_rrand

  function miller_rabin_test(n, k) result(res)
    logical :: res
    integer(huge), intent(in) :: n
    integer, intent(in) :: k

    integer(huge), dimension(max_decompose) :: f
    integer(huge)                     :: s, d, i, a, x, r

    res = .true.
    f = 0

    if ( (n <= 2) .and. (n > 0) ) return
    if ( mod(n, 2) == 0 ) then
       res = .false.
       return
    end if

    call find_factors(n-1, f)
    s = count(f == 2)
    d = (n-1) / (2 ** s)
    loop:  do i = 1, k
       a = int_rrand(2_huge, n-2)
       x = mod(a ** d, n)

       if ( x == 1 ) cycle
       do r = 0, s-1
          if ( x == ( n - 1 ) ) cycle loop
          x = mod(x*x, n)
       end do
       if ( x == (n-1) ) cycle
       res = .false.
       return
    end do loop
    res = .true.
  end function miller_rabin_test

end module Miller_Rabin
