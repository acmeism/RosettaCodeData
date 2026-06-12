program main
    implicit none
    ! Maximum matrix size for static allocation
    integer, parameter :: max_size = 10
    ! Type definitions
    real(8) :: matrix(max_size, max_size)
    real(8) :: vector(max_size)
    ! Variables for the first problem (2x2 system)
    real(8) :: guesses2(2), sol2(2)
    ! Variables for the second problem (3x3 system)
    real(8) :: guesses3(3), sol3(3)
    ! Interface for function pointers
    interface
        function fun_vec(x, n) result(res)
            integer, intent(in) :: n
            real(8), intent(in) :: x(n)
            real(8) :: res
        end function
    end interface

    ! First problem: Solve the 2x2 nonlinear system
    guesses2 = [1.2d0, 1.2d0]
    call solve(2, f1, f2, jacob_dummy, &
               jacob1_1, jacob1_2, jacob_dummy, &
               jacob2_1, jacob2_2, jacob_dummy, &
               jacob_dummy, jacob_dummy, jacob_dummy, &
               guesses2, sol2)
    write(*, '(/,A, F10.7, A, F10.7)') 'Approximate solutions are x = ', sol2(1), ', y = ', sol2(2)

    ! Second problem: Solve the 3x3 nonlinear system
    guesses3 = [1.0d0, 1.0d0, 0.0d0]
    call solve(3, f3, f4, f5, &
               jacob3_1, jacob3_2, jacob3_3, &
               jacob4_1, jacob4_2, jacob4_3, &
               jacob5_1, jacob5_2, jacob5_3, &
               guesses3, sol3)
    write(*, '(A, F10.7, A, F10.7, A, F10.7)') &
        'Approximate solutions are x = ', sol3(1), ', y = ', sol3(2), ', z = ', sol3(3)

contains

    ! Matrix subtraction: result = m1 - m2 using reshape
    subroutine mat_sub(m1, rows, cols, m2, result)
        integer, intent(in) :: rows, cols
        real(8), intent(in) :: m1(rows, cols), m2(rows, cols)
        real(8), intent(out) :: result(rows, cols)
        real(8) :: flat_m1(rows * cols), flat_m2(rows * cols), flat_result(rows * cols)
        ! Check dimensions
        if (size(m1, 1) /= size(m2, 1) .or. size(m1, 2) /= size(m2, 2)) then
            write(*, *) 'Error: Matrices cannot be subtracted.'
            stop
        end if
        ! Flatten matrices to 1D arrays
        flat_m1 = reshape(m1, [rows * cols])
        flat_m2 = reshape(m2, [rows * cols])
        ! Perform element-wise subtraction
        flat_result = flat_m1 - flat_m2
        ! Reshape back to matrix
        result = reshape(flat_result, [rows, cols])
    end subroutine mat_sub

    ! Matrix inverse using Gauss-Jordan elimination
    subroutine mat_inverse(m, n, inv)
        integer, intent(in) :: n
        real(8), intent(in) :: m(n, n)
        real(8), intent(out) :: inv(n, n)
        real(8) :: aug(n, 2*n)
        integer :: i
        if (size(m, 1) /= size(m, 2)) then
            write(*, *) 'Error: Not a square matrix.'
            stop
        end if
        aug = 0.0d0
        do i = 1, n
            aug(i, 1:n) = m(i, :)
            aug(i, n+i) = 1.0d0
        end do
        call to_reduced_row_echelon_form(aug, n, 2*n)
        inv = aug(:, n+1:2*n)
    end subroutine mat_inverse

    ! Gauss-Jordan elimination to reduced row echelon form
    subroutine to_reduced_row_echelon_form(m, rows, cols)
        integer, intent(in) :: rows, cols
        real(8), intent(inout) :: m(rows, cols)
        integer :: lead, r, i, k
        real(8) :: div, mult, temp(cols)
        lead = 1
        do r = 1, rows
            if (cols < lead) exit
            i = r
            do while (m(i, lead) == 0.0d0)
                i = i + 1
                if (i > rows) then
                    i = r
                    lead = lead + 1
                    if (lead > cols) return
                end if
            end do
            if (i /= r) then
                temp = m(r, :)
                m(r, :) = m(i, :)
                m(i, :) = temp
            end if
            div = m(r, lead)
            if (div /= 0.0d0) then
                m(r, :) = m(r, :) / div
            end if
            do k = 1, rows
                if (k /= r) then
                    mult = m(k, lead)
                    m(k, :) = m(k, :) - m(r, :) * mult
                end if
            end do
            lead = lead + 1
        end do
    end subroutine to_reduced_row_echelon_form

    ! Newton's method solver for nonlinear systems
    subroutine solve(n, f1, f2, f3, j11, j12, j13, j21, j22, j23, j31, j32, j33, guesses, sol)
        integer, intent(in) :: n
        procedure(fun_vec) :: f1, f2, f3, j11, j12, j13, j21, j22, j23, j31, j32, j33
        real(8), intent(in) :: guesses(n)
        real(8), intent(out) :: sol(n)
        real(8) :: gu1(n), gu2(n), g(n, 1), t(n), f(n, 1), jac(n, n), g1(n, 1)
        real(8) :: jac_inv(n, n), temp(n, 1), tol, diff
        integer :: iter, max_iter, i, j
        logical :: converged
        tol = 1.0d-8
        max_iter = 12
        gu2 = guesses
        iter = 0
        do
            gu1 = gu2
            g(:, 1) = gu1
            t(1) = f1(gu1, n)
            if (n >= 2) t(2) = f2(gu1, n)
            if (n >= 3) t(3) = f3(gu1, n)
            f(:, 1) = t(1:n)
            do i = 1, n
                do j = 1, n
                    if (i <= 3 .and. j <= 3 .and. n >= max(i, j)) then
                        select case (i)
                            case (1)
                                select case (j)
                                    case (1); jac(i, j) = j11(gu1, n)
                                    case (2); jac(i, j) = j12(gu1, n)
                                    case (3); jac(i, j) = j13(gu1, n)
                                end select
                            case (2)
                                select case (j)
                                    case (1); jac(i, j) = j21(gu1, n)
                                    case (2); jac(i, j) = j22(gu1, n)
                                    case (3); jac(i, j) = j23(gu1, n)
                                end select
                            case (3)
                                select case (j)
                                    case (1); jac(i, j) = j31(gu1, n)
                                    case (2); jac(i, j) = j32(gu1, n)
                                    case (3); jac(i, j) = j33(gu1, n)
                                end select
                        end select
                    end if
                end do
            end do
            call mat_inverse(jac, n, jac_inv)
            temp = matmul(jac_inv, f)
            call mat_sub(g, n, 1, temp, g1)
            gu2 = g1(:, 1)
            iter = iter + 1
            converged = .true.
            do i = 1, n
                diff = abs(gu2(i) - gu1(i))
                if (diff > tol) then
                    converged = .false.
                    exit
                end if
            end do
            if (converged .or. iter >= max_iter) exit
        end do
        sol = gu2
    end subroutine solve

    ! Functions for the first problem
    function f1(x, n) result(res)
        integer, intent(in) :: n
        real(8), intent(in) :: x(n)
        real(8) :: res
        res = -x(1)*x(1) + x(1) + 0.5d0 - x(2)
    end function f1

    function f2(x, n) result(res)
        integer, intent(in) :: n
        real(8), intent(in) :: x(n)
        real(8) :: res
        res = x(2) + 5.0d0*x(1)*x(2) - x(1)*x(1)
    end function f2

    function jacob1_1(x, n) result(res)
        integer, intent(in) :: n
        real(8), intent(in) :: x(n)
        real(8) :: res
        res = -2.0d0*x(1) + 1.0d0
    end function jacob1_1

    function jacob1_2(x, n) result(res)
        integer, intent(in) :: n
        real(8), intent(in) :: x(n)
        real(8) :: res
        res = -1.0d0
    end function jacob1_2

    function jacob2_1(x, n) result(res)
        integer, intent(in) :: n
        real(8), intent(in) :: x(n)
        real(8) :: res
        res = 5.0d0*x(2) - 2.0d0*x(1)
    end function jacob2_1

    function jacob2_2(x, n) result(res)
        integer, intent(in) :: n
        real(8), intent(in) :: x(n)
        real(8) :: res
        res = 1.0d0 + 5.0d0*x(1)
    end function jacob2_2

    ! Functions for the second problem
    function f3(x, n) result(res)
        integer, intent(in) :: n
        real(8), intent(in) :: x(n)
        real(8) :: res
        res = 9.0d0*x(1)*x(1) + 36.0d0*x(2)*x(2) + 4.0d0*x(3)*x(3) - 36.0d0
    end function f3

    function f4(x, n) result(res)
        integer, intent(in) :: n
        real(8), intent(in) :: x(n)
        real(8) :: res
        res = x(1)*x(1) - 2.0d0*x(2)*x(2) - 20.0d0*x(3)
    end function f4

    function f5(x, n) result(res)
        integer, intent(in) :: n
        real(8), intent(in) :: x(n)
        real(8) :: res
        res = x(1)*x(1) - x(2)*x(2) + x(3)*x(3)
    end function f5

    function jacob3_1(x, n) result(res)
        integer, intent(in) :: n
        real(8), intent(in) :: x(n)
        real(8) :: res
        res = 18.0d0*x(1)
    end function jacob3_1

    function jacob3_2(x, n) result(res)
        integer, intent(in) :: n
        real(8), intent(in) :: x(n)
        real(8) :: res
        res = 72.0d0*x(2)
    end function jacob3_2

    function jacob3_3(x, n) result(res)
        integer, intent(in) :: n
        real(8), intent(in) :: x(n)
        real(8) :: res
        res = 8.0d0*x(3)
    end function jacob3_3

    function jacob4_1(x, n) result(res)
        integer, intent(in) :: n
        real(8), intent(in) :: x(n)
        real(8) :: res
        res = 2.0d0*x(1)
    end function jacob4_1

    function jacob4_2(x, n) result(res)
        integer, intent(in) :: n
        real(8), intent(in) :: x(n)
        real(8) :: res
        res = -4.0d0*x(2)
    end function jacob4_2

    function jacob4_3(x, n) result(res)
        integer, intent(in) :: n
        real(8), intent(in) :: x(n)
        real(8) :: res
        res = -20.0d0
    end function jacob4_3

    function jacob5_1(x, n) result(res)
        integer, intent(in) :: n
        real(8), intent(in) :: x(n)
        real(8) :: res
        res = 2.0d0*x(1)
    end function jacob5_1

    function jacob5_2(x, n) result(res)
        integer, intent(in) :: n
        real(8), intent(in) :: x(n)
        real(8) :: res
        res = -2.0d0*x(2)
    end function jacob5_2

    function jacob5_3(x, n) result(res)
        integer, intent(in) :: n
        real(8), intent(in) :: x(n)
        real(8) :: res
        res = 2.0d0*x(3)
    end function jacob5_3

    ! Dummy Jacobian function
    function jacob_dummy(x, n) result(res)
        integer, intent(in) :: n
        real(8), intent(in) :: x(n)
        real(8) :: res
        res = 0.0d0
    end function jacob_dummy

end program main
