program romberg_integration
    implicit none

    ! Maximum number of steps
    integer, parameter :: MAX_STEPS = 10

    ! Function interface for integration functions
    abstract interface
        real(8) function func_interface(x)
            real(8), intent(in) :: x
        end function func_interface
    end interface

    ! Variables for results
    real(8) :: result1, result2

    ! Test integration
    write(*,*) 'Integration of sin(x) over [0, 1] with a maximum of 5 steps:'
    result1 = romberg(f_sin, 0.0d0, 1.0d0, 5, 1.0d-8)
    write(*,'(f12.8)') result1
    write(*,*)

    write(*,*) 'Integration of exp(x) over [-3, 3] with a maximum of 5 steps:'
    result2 = romberg(f_exp, -3.0d0, 3.0d0, 5, 1.0d-8)
    write(*,'(f12.8)') result2

contains

    ! Prints a row of the Romberg table
    subroutine print_row(i, R)
        implicit none
        integer, intent(in) :: i
        real(8), intent(in) :: R(0:)
        integer :: j

        write(*,'(A,I0,A)', advance='no') 'R[', i, '] = '
        do j = 0, i
            write(*,'(f12.8,A)', advance='no') R(j), ' '
        end do
        write(*,*)
    end subroutine print_row

    ! Calculates the integral of a function using Romberg integration
    function romberg(f, a, b, max_steps, acc) result(integral)
        implicit none
        procedure(func_interface) :: f
        real(8), intent(in) :: a, b, acc
        integer, intent(in) :: max_steps
        real(8) :: integral

        integer :: i, j, ep
        real(8) :: Rp(0:MAX_STEPS-1), Rc(0:MAX_STEPS-1)
        real(8) :: h, c, nk

        ! Initialize
        h = b - a
        Rp(0) = (f(a) + f(b)) * h * 0.5d0
        call print_row(0, Rp)

        do i = 1, max_steps - 1
            h = h / 2.0d0
            c = 0.0d0
            ep = 2**(i-1)  ! 2^(i-1)

            ! Calculate sum for trapezoidal rule refinement
            do j = 1, ep
                c = c + f(a + (2*j - 1) * h)
            end do

            Rc(0) = h * c + 0.5d0 * Rp(0)

            ! Richardson extrapolation
            do j = 1, i
                nk = 4.0d0**j
                Rc(j) = (nk * Rc(j-1) - Rp(j-1)) / (nk - 1.0d0)
            end do

            ! Print current row
            call print_row(i, Rc)

            ! Check convergence
            if (i > 1 .and. abs(Rp(i-1) - Rc(i)) < acc) then
                integral = Rc(i)
                return
            end if

            ! Swap arrays (copy Rc to Rp)
            Rp(0:i) = Rc(0:i)
        end do

        integral = Rp(max_steps-1)
    end function romberg

    ! Test function: sin(x)
    function f_sin(x) result(y)
        implicit none
        real(8), intent(in) :: x
        real(8) :: y
        y = sin(x)
    end function f_sin

    ! Test function: exp(x)
    function f_exp(x) result(y)
        implicit none
        real(8), intent(in) :: x
        real(8) :: y
        y = exp(x)
    end function f_exp

end program romberg_integration
