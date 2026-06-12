module special_factorials
    use iso_fortran_env
    implicit none
    private
    public :: superfactorial, hyperfactorial, alternating_factorial, exponential_factorial
    public :: inverse_factorial, num_digits_exp_factorial

contains

    ! Compute regular factorial n! (used in superfactorial and alternating factorial)
    function factorial(n) result(res)
        integer(kind=16), intent(in) :: n
        integer(kind=16) :: res
        integer :: i
        if (n < 0) then
            res = 0
            return
        end if
        if (n <= 1) then
            res = 1
            return
        end if
        res = 1
        do i = 2, n
            res = res * i
        end do
    end function factorial

    ! Compute superfactorial sf(n) = 1! * 2! * ... * n!
    function superfactorial(n) result(res)
        integer, intent(in) :: n
        integer(kind=16) :: res
        integer(kind=16) :: i
        if (n < 0) then
            res = 0
            return
        end if
        if (n == 0) then
            res = 1
            return
        end if
        res = 1
        do i = 1, n
            res = res * factorial(i)
        end do
    end function superfactorial

    ! Compute hyperfactorial H(n) = 1^1 * 2^2 * ... * n^n
    function hyperfactorial(n) result(res)
        integer, intent(in) :: n
        integer(kind=16) :: res
        integer :: i
        if (n < 0) then
            res = 0
            return
        end if
        if (n == 0) then
            res = 1
            return
        end if
        res = 1
        do i = 1, n
            res = res * (i**i)
        end do
    end function hyperfactorial

    ! Compute alternating factorial af(n) = sum((-1)^(n-i) * i!)
    function alternating_factorial(n) result(res)
        integer, intent(in) :: n
        integer(kind=16) :: res
        integer(kind=16) :: i
        if (n < 0) then
            res = 0
            return
        end if
        if (n == 0) then
            res = 0
            return
        end if
        res = 0
        do i = 1, n
            res = res + (-1)**(n-i) * factorial(i)
        end do
    end function alternating_factorial

    ! Compute exponential factorial n$ = n^(n-1)^(n-2)^...^1
    function exponential_factorial(n) result(res)
        integer, intent(in) :: n
        integer(kind=16) :: res
        integer :: i
        if (n < 0) then
            res = 0
            return
        end if
        if (n == 0) then
            res = 0
            return
        end if
        if (n == 1) then
            res = 1
            return
        end if
        res = 1
        do i = 1, n
            res = i**res
            if (res < 0) then ! Check for overflow
                res = -1
                return
            end if
        end do
    end function exponential_factorial

function num_digits_exp_factorial(n) result(digits)
    integer, intent(in) :: n
    integer :: digits
    real(kind=16) :: log_sum, log_val
    integer :: i
    if (n <= 0) then
        digits = 0
        return
    end if
    if (n == 1) then
        digits = 1
        return
    end if
    ! Compute log10(n$) = log10(n^(n-1)^(n-2)^...^2^1)
    ! = (n-1)^(n-2)^...^2^1 * log10(n)
    log_val = 2.0d0 ! Start with 2^1
    do i = 3, n-1
        log_val = real(i, kind=16) ** log_val
    end do
    log_sum = log_val * log10(real(n, kind=16))
    digits = floor(log_sum) + 1
    if (digits < 0) then ! Guard against overflow
        digits = -1
    end if
end function num_digits_exp_factorial

    ! Compute inverse factorial rf(x) such that x = n!
    function inverse_factorial(x) result(n)
        integer(kind=16), intent(in) :: x
        integer :: n
        integer(kind=16) :: fact
        integer :: i
        if (x <= 0) then
            n = -1 ! Undefined
            return
        end if
        fact = 1
        do i = 0, 20 ! Check up to 20! to cover 3628800
            if (fact == x) then
                n = i
                return
            end if
            if (fact > x) then
                n = -1 ! Undefined
                return
            end if
            fact = fact * (i + 1)
        end do
        n = -1 ! Undefined if x > 20!
    end function inverse_factorial

    ! Compute factorial using Gamma function for real input
    function gamma_factorial(n) result(res)
        real*16, intent(in) :: n
        real*16 :: res
        if (n < 0.0d0) then
            res = 0.0d0
            return
        end if
        res = gamma(n + 1.0d0) ! Gamma(n+1) = n!
    end function gamma_factorial

end module special_factorials

program test_special_factorials
    use special_factorials
    implicit none
    integer :: i
    integer(kind=16) :: values(9)
    integer(kind=16) :: inv_inputs(11) = [1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800, 119]
    integer :: n

    ! Superfactorial sf(n) for n = 0 to 9
    print *, 'Superfactorial sf(n) for n = 0 to 9:'
    do i = 0, 9
        print '(A, I2, A, I25)', '  sf(', i, ') = ', superfactorial(i)
    end do

    ! Hyperfactorial H(n) for n = 0 to 9
    print *, 'Hyperfactorial H(n) for n = 0 to 9:'
    do i = 0, 9
        print '(A, I2, A, I35)', '  H(', i, ') = ', hyperfactorial(i)
    end do

    ! Alternating factorial af(n) for n = 0 to 9
    print *, 'Alternating factorial af(n) for n = 0 to 9:'
    do i = 0, 9
        print '(A, I2, A, I20)', '  af(', i, ') = ', alternating_factorial(i)
    end do

    ! Exponential factorial n$ for n = 0 to 4
    print *, 'Exponential factorial n$ for n = 0 to 4:'
    do i = 0, 4
        print '(A, I1, A, I20)', '  ', i, '$ = ', exponential_factorial(i)
    end do

    ! Number of digits in 5$
    write(*, '(a)',advance = "no")  'Number of digits in 5$:'
    print '(I0,/)', num_digits_exp_factorial(5)

    ! Inverse factorial for given inputs
    print *, 'Inverse factorial rf(x):'
    do i = 1, 11
        n = inverse_factorial(inv_inputs(i))
        if (n == -1) then
            print '(A, I10, A)', '  rf(', inv_inputs(i), ') = undefined'
        else
            print '(A, I10, A, I0)', '  rf(', inv_inputs(i), ') = ', n
        end if
    end do
end program test_special_factorials
