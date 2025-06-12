program harmonic_numbers
    use :: iso_fortran_env, only: int64, output_unit
    implicit none
    integer, parameter :: real64 = selected_real_kind(15, 307)

    type :: fraction
        integer(int64) :: numerator
        integer(int64) :: denominator
    end type fraction

    integer :: i, target_int
    type(fraction) :: h_exact
    real(real64) :: sum_h, h_decimal
    character(len=200) :: fmt_str

    ! Print first 20 harmonic numbers as fractions
    write(output_unit, '(a)') "## First 20 Harmonic Numbers"
    write(output_unit, '(a)') "**Fractional Form**"
    h_exact = fraction(0_int64, 1_int64)
    do i = 1, 20
        h_exact = add_reciprocal(h_exact, i)
        write(output_unit, '(i2, ": ", i0, "/", i0)') i, h_exact%numerator, h_exact%denominator
    end do

    ! Print decimal approximations
    write(output_unit, '(/, a)') "**Decimal Approximations**"
    h_exact = fraction(0_int64, 1_int64)
    do i = 1, 20
        h_exact = add_reciprocal(h_exact, i)
        h_decimal = real(h_exact%numerator, real64) / real(h_exact%denominator, real64)
        write(output_unit, '(i2, ": ", f0.12)') i, h_decimal
    end do

    ! Find positions where harmonic numbers exceed integers 1-10
    write(output_unit, '(/, a)') "## Positions Where H? First Exceeds Integers"
    write(output_unit, '(a)') "| Target | Position (n) | Decimal Approximation |"
    write(output_unit, '(a)') "|--------|--------------|------------------------|"
    write(fmt_str, '(a)') '(a, i2, a, T10, A, i0,T25, a, f0.6, T50,a)'

    do target_int = 1, 10
        sum_h = 0._real64
        i = 0
        do
            i = i + 1
            sum_h = sum_h + 1.0_real64 / real(i, real64)
            if (sum_h > real(target_int, real64)) then
                if (target_int <= 5 .or. target_int >= 6) then
                    write(output_unit, FMT_STR) "| **", target_int, "**","| ", i, &
                        "| ", real(sum_h, real64), "|"
                end if
                exit
            end if
        end do
    end do

contains

    function add_reciprocal(h, n) result(new_h)
        type(fraction), intent(in) :: h
        integer, intent(in) :: n
        type(fraction) :: new_h
        integer(int64) :: common_denominator, new_numerator, divisor

        common_denominator = h%denominator * int(n, int64)
        new_numerator = h%numerator * int(n, int64) + h%denominator
        divisor = gcd(new_numerator, common_denominator)

        new_h%numerator = new_numerator / divisor
        new_h%denominator = common_denominator / divisor
    end function add_reciprocal

    recursive function gcd(a, b) result(greatest_common_divisor)
        integer(int64), intent(in) :: a, b
        integer(int64) :: greatest_common_divisor

        if (b == 0) then
            greatest_common_divisor = a
        else
            greatest_common_divisor = gcd(b, mod(a, b))
        end if
    end function gcd

end program harmonic_numbers
