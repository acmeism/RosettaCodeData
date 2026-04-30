module matrix_operations
    use, intrinsic :: iso_fortran_env, only: real64, int64
    implicit none

    type :: Matrix
        real(real64), allocatable :: data(:, :)
        integer :: rows = 0
        integer :: cols = 0
    contains
        procedure :: getRows
        procedure :: getCols
        procedure :: validateDimensions
        procedure :: validateMultiplication
        procedure :: validateSquarePowerOfTwo
        procedure :: add_matrices
        procedure :: subtract_matrices
        procedure :: multiply_matrices
        procedure :: strassen
        procedure :: toQuarters
        procedure :: toStringWithPrecision
        generic :: operator(+) => add_matrices
        generic :: operator(-) => subtract_matrices
        generic :: operator(*) => multiply_matrices
    end type Matrix

    interface Matrix
        procedure :: create_matrix
    end interface Matrix

    type :: MatrixArray4
        type(Matrix) :: matrices(4)
    end type MatrixArray4

contains

    function create_matrix(input_data) result(mat)
        real(real64), intent(in) :: input_data(:, :)
        type(Matrix) :: mat

        mat%rows = size(input_data, 1)
        mat%cols = size(input_data, 2)
        allocate(mat%data(mat%rows, mat%cols))
        mat%data = input_data
    end function create_matrix

    function getRows(this) result(rows)
        class(Matrix), intent(in) :: this
        integer :: rows
        rows = this%rows
    end function getRows

    function getCols(this) result(cols)
        class(Matrix), intent(in) :: this
        integer :: cols
        cols = this%cols
    end function getCols

    subroutine validateDimensions(this, other)
        class(Matrix), intent(in) :: this, other
        if (this%getRows() /= other%getRows() .or. this%getCols() /= other%getCols()) then
            error stop "Matrices must have the same dimensions."
        end if
    end subroutine validateDimensions

    subroutine validateMultiplication(this, other)
        class(Matrix), intent(in) :: this, other
        if (this%getCols() /= other%getRows()) then
            error stop "Cannot multiply these matrices."
        end if
    end subroutine validateMultiplication

    subroutine validateSquarePowerOfTwo(this)
        class(Matrix), intent(in) :: this
        integer :: n

        if (this%getRows() /= this%getCols()) then
            error stop "Matrix must be square."
        end if

        n = this%getRows()
        if (n == 0 .or. iand(n, n-1) /= 0) then
            error stop "Size of matrix must be a power of two."
        end if
    end subroutine validateSquarePowerOfTwo

    function add_matrices(this, other) result(result_mat)
        class(Matrix), intent(in) :: this, other
        type(Matrix) :: result_mat
        integer :: i, j

        call this%validateDimensions(other)

        result_mat%rows = this%rows
        result_mat%cols = this%cols
        allocate(result_mat%data(result_mat%rows, result_mat%cols))

        do j = 1, result_mat%cols
            do i = 1, result_mat%rows
                result_mat%data(i, j) = this%data(i, j) + other%data(i, j)
            end do
        end do
    end function add_matrices

    function subtract_matrices(this, other) result(result_mat)
        class(Matrix), intent(in) :: this, other
        type(Matrix) :: result_mat
        integer :: i, j

        call this%validateDimensions(other)

        result_mat%rows = this%rows
        result_mat%cols = this%cols
        allocate(result_mat%data(result_mat%rows, result_mat%cols))

        do j = 1, result_mat%cols
            do i = 1, result_mat%rows
                result_mat%data(i, j) = this%data(i, j) - other%data(i, j)
            end do
        end do
    end function subtract_matrices

    function multiply_matrices(this, other) result(result_mat)
        class(Matrix), intent(in) :: this, other
        type(Matrix) :: result_mat
        integer :: i, j, k
        real(real64) :: sum_val

        call this%validateMultiplication(other)

        result_mat%rows = this%rows
        result_mat%cols = other%cols
        allocate(result_mat%data(result_mat%rows, result_mat%cols))

        do i = 1, result_mat%rows
            do j = 1, result_mat%cols
                sum_val = 0.0_real64
                do k = 1, this%cols
                    sum_val = sum_val + this%data(i, k) * other%data(k, j)
                end do
                result_mat%data(i, j) = sum_val
            end do
        end do
    end function multiply_matrices

    function params(r, c) result(p)
        integer, intent(in) :: r, c
        integer :: p(4, 6)

        p(1, :) = [1, r, 1, c, 1, 1]
        p(2, :) = [1, r, c+1, 2*c, 1, c+1]
        p(3, :) = [r+1, 2*r, 1, c, r+1, 1]
        p(4, :) = [r+1, 2*r, c+1, 2*c, r+1, c+1]
    end function params

    function toQuarters(this) result(quarters)
        class(Matrix), intent(in) :: this
        type(MatrixArray4) :: quarters
        integer :: r, c, k, i, j
        integer :: p(4, 6)
        real(real64), allocatable :: q_data(:, :)

        r = this%getRows() / 2
        c = this%getCols() / 2
        p = params(r, c)

        do k = 1, 4
            allocate(q_data(r, c))
            do j = p(k, 3), p(k, 4)
                do i = p(k, 1), p(k, 2)
                    q_data(i - p(k, 5) + 1, j - p(k, 6) + 1) = this%data(i, j)
                end do
            end do
            quarters%matrices(k) = Matrix(q_data)
            deallocate(q_data)
        end do
    end function toQuarters

    function fromQuarters(q) result(mat)
        type(MatrixArray4), intent(in) :: q
        type(Matrix) :: mat
        integer :: r, c, k, i, j
        integer :: p(4, 6)
        real(real64), allocatable :: m_data(:, :)

        r = q%matrices(1)%getRows()
        c = q%matrices(1)%getCols()
        p = params(r, c)

        allocate(m_data(2*r, 2*c))
        m_data = 0.0_real64

        do k = 1, 4
            do j = p(k, 3), p(k, 4)
                do i = p(k, 1), p(k, 2)
                    m_data(i, j) = q%matrices(k)%data(i - p(k, 5) + 1, j - p(k, 6) + 1)
                end do
            end do
        end do

        mat = Matrix(m_data)
        deallocate(m_data)
    end function fromQuarters

    function strassen(this, other) result(result_mat)
        class(Matrix), intent(in) :: this, other
        type(Matrix) :: result_mat
        type(MatrixArray4) :: qa, qb, q
        type(Matrix) :: p1, p2, p3, p4, p5, p6, p7
        integer :: r, i

        call this%validateSquarePowerOfTwo()
        call other%validateSquarePowerOfTwo()

        if (this%getRows() /= other%getRows() .or. this%getCols() /= other%getCols()) then
            error stop "Matrices must be square and of equal size for Strassen multiplication."
        end if

        if (this%getRows() == 1) then
            result_mat = this * other
            return
        end if

        qa = this%toQuarters()
        qb = other%toQuarters()

        p1 = (qa%matrices(2) - qa%matrices(4)) * (qb%matrices(3) + qb%matrices(4))
        p2 = (qa%matrices(1) + qa%matrices(4)) * (qb%matrices(1) + qb%matrices(4))
        p3 = (qa%matrices(1) - qa%matrices(3)) * (qb%matrices(1) + qb%matrices(2))
        p4 = (qa%matrices(1) + qa%matrices(2)) * qb%matrices(4)
        p5 = qa%matrices(1) * (qb%matrices(2) - qb%matrices(4))
        p6 = qa%matrices(4) * (qb%matrices(3) - qb%matrices(1))
        p7 = (qa%matrices(3) + qa%matrices(4)) * qb%matrices(1)

        q%matrices(1) = p1 + p2 - p4 + p6
        q%matrices(2) = p4 + p5
        q%matrices(3) = p6 + p7
        q%matrices(4) = p2 - p3 + p5 - p7

        result_mat = fromQuarters(q)
    end function strassen

    function toStringWithPrecision(this, p) result(str)
        class(Matrix), intent(in) :: this
        integer, intent(in) :: p
        character(:), allocatable :: str
        character(100) :: buffer
        integer :: i, j
        real(real64) :: rounded_val

        str = ''
        do i = 1, this%rows
            str = str // '['
            do j = 1, this%cols
                write(buffer, '(F0.' // trim(adjustl(int2str(p))) // ')') this%data(i, j)
                str = str // trim(adjustl(buffer))
                if (j < this%cols) then
                    str = str // ', '
                end if
            end do
            str = str // ']' // new_line('a')
        end do
    end function toStringWithPrecision

    function int2str(i) result(str)
        integer, intent(in) :: i
        character(20) :: str
        write(str, *) i
        str = adjustl(str)
    end function int2str

end module matrix_operations

program main
    use matrix_operations
    implicit none

    type(Matrix) :: a, b, c, d, e, f, result

    ! Initialize matrices (Fortran is column-major, so we need to transpose)
    a = Matrix(reshape([1.0_real64, 2.0_real64, 3.0_real64, 4.0_real64], [2, 2]))
    b = Matrix(reshape([5.0_real64, 6.0_real64, 7.0_real64, 8.0_real64], [2, 2]))
    c = Matrix(reshape([1.0_real64, 1.0_real64, 1.0_real64, 1.0_real64, &
                       1.0_real64, 4.0_real64, 9.0_real64, 16.0_real64, &
                       1.0_real64, 8.0_real64, 27.0_real64, 64.0_real64, &
                       1.0_real64, 16.0_real64, 81.0_real64, 256.0_real64], [4, 4]))
    d = Matrix(reshape([4.0_real64, -3.0_real64, 4.0_real64/3.0_real64, -1.0_real64/4.0_real64, &
                       -13.0_real64/3.0_real64, 19.0_real64/4.0_real64, -7.0_real64/3.0_real64, 11.0_real64/24.0_real64, &
                       3.0_real64/2.0_real64, -2.0_real64, 7.0_real64/6.0_real64, -1.0_real64/4.0_real64, &
                       -1.0_real64/6.0_real64, 1.0_real64/4.0_real64, -1.0_real64/6.0_real64, 1.0_real64/24.0_real64], [4, 4]))
    e = Matrix(reshape([1.0_real64, 2.0_real64, 3.0_real64, 4.0_real64, &
                       5.0_real64, 6.0_real64, 7.0_real64, 8.0_real64, &
                       9.0_real64, 10.0_real64, 11.0_real64, 12.0_real64, &
                       13.0_real64, 14.0_real64, 15.0_real64, 16.0_real64], [4, 4]))
    f = Matrix(reshape([1.0_real64, 0.0_real64, 0.0_real64, 0.0_real64, &
                       0.0_real64, 1.0_real64, 0.0_real64, 0.0_real64, &
                       0.0_real64, 0.0_real64, 1.0_real64, 0.0_real64, &
                       0.0_real64, 0.0_real64, 0.0_real64, 1.0_real64], [4, 4]))

    print *, "Using 'normal' matrix multiplication:"

    result = a * b
    print *, "  a * b = "
    call print_matrix(result)
    print *

    result = c * d
    print *, "  c * d = "
    print *, trim(result%toStringWithPrecision(6))
    print *

    result = e * f
    print *, "  e * f = "
    call print_matrix(result)
    print *

    print *, "Using 'Strassen' matrix multiplication:"

    result = a%strassen(b)
    print *, "  a * b = "
    call print_matrix(result)
    print *

    result = c%strassen(d)
    print *, "  c * d = "
    print *, trim(result%toStringWithPrecision(6))
    print *

    result = e%strassen(f)
    print *, "  e * f = "
    call print_matrix(result)

contains

    subroutine print_matrix(mat)
        type(Matrix), intent(in) :: mat
        integer :: i, j

        do i = 1, mat%rows
            write(*, '(A)', advance='no') '['
            do j = 1, mat%cols
                write(*, '(G0.6)', advance='no') mat%data(i, j)
                if (j < mat%cols) then
                    write(*, '(A)', advance='no') ', '
                end if
            end do
            write(*, '(A)') ']'
        end do
    end subroutine print_matrix

end program main
