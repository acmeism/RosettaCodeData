program pfaffian_calculator
    implicit none

    ! Constants for Faffian types
    integer, parameter :: PFAFFIAN = 1
    integer, parameter :: HFAFFIAN = 2

    ! Maximum matrix size for static allocation
    integer, parameter :: MAX_SIZE = 10
    integer, parameter :: MAX_FACTORIAL = 3628800  ! 10!

    ! Type for signed permutations
    type :: signed_perm
        integer :: permutation(MAX_SIZE)
        integer :: sign
    end type signed_perm

    ! Variables
    integer :: i, j, k, matrix_idx, faffian_type
    integer :: test_matrices(4, MAX_SIZE, MAX_SIZE)
    integer :: matrix_sizes(4)
    integer :: current_matrix(MAX_SIZE, MAX_SIZE)
    integer :: result
    logical :: valid_result

    ! Initialize test matrices
    call initialize_test_matrices(test_matrices, matrix_sizes)

    ! Process each test matrix
    do matrix_idx = 1, 4
        ! Copy current matrix
        do i = 1, matrix_sizes(matrix_idx)
            do j = 1, matrix_sizes(matrix_idx)
                current_matrix(i, j) = test_matrices(matrix_idx, i, j)
            end do
        end do

        ! Print matrix
        call print_matrix(current_matrix, matrix_sizes(matrix_idx))

        ! Compute both Pfaffian and Hfaffian
        do faffian_type = PFAFFIAN, HFAFFIAN
            call compute_faffian(current_matrix, matrix_sizes(matrix_idx), &
                                faffian_type, result, valid_result)
            if (valid_result) then
                if (faffian_type == PFAFFIAN) then
                    write(*, '(A, I0)') 'Pfaffian: ', result
                else
                    write(*, '(A, I0)') 'Hfaffain: ', result
                end if
            end if
        end do
        write(*,*)
    end do

contains

    subroutine initialize_test_matrices(matrices, sizes)
        integer, intent(out) :: matrices(4, MAX_SIZE, MAX_SIZE)
        integer, intent(out) :: sizes(4)

        ! Initialize all matrices to zero
        matrices = 0

        ! Matrix 1: 2x2
        sizes(1) = 2
        matrices(1, 1, 1) =  0; matrices(1, 1, 2) =  1
        matrices(1, 2, 1) = -1; matrices(1, 2, 2) =  0

        ! Matrix 2: 4x4
        sizes(2) = 4
        matrices(2, 1, 1) =  0; matrices(2, 1, 2) =  1; matrices(2, 1, 3) = -1; matrices(2, 1, 4) =  2
        matrices(2, 2, 1) = -1; matrices(2, 2, 2) =  0; matrices(2, 2, 3) =  3; matrices(2, 2, 4) = -4
        matrices(2, 3, 1) =  1; matrices(2, 3, 2) = -3; matrices(2, 3, 3) =  0; matrices(2, 3, 4) =  5
        matrices(2, 4, 1) = -2; matrices(2, 4, 2) =  4; matrices(2, 4, 3) = -5; matrices(2, 4, 4) =  0

        ! Matrix 3: 6x6 (symmetric - will fail antisymmetric test)
        sizes(3) = 6
        matrices(3, 1, :6) = [1, 2, 3, 4, 5, 6]
        matrices(3, 2, :6) = [2, 7, 8, 9, 10, 11]
        matrices(3, 3, :6) = [3, 8, 12, 13, 14, 15]
        matrices(3, 4, :6) = [4, 9, 13, 16, 17, 18]
        matrices(3, 5, :6) = [5, 10, 14, 17, 19, 20]
        matrices(3, 6, :6) = [6, 11, 15, 18, 20, 21]

        ! Matrix 4: 10x10
        sizes(4) = 10
        matrices(4, 1, :10) = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        matrices(4, 2, :10) = [-1, 0, 8, 7, 6, 5, 4, 3, 2, 1]
        matrices(4, 3, :10) = [-2, -8, 0, 1, 2, 3, 4, 5, 6, 7]
        matrices(4, 4, :10) = [-3, -7, -1, 0, 6, 5, 4, 3, 2, 1]
        matrices(4, 5, :10) = [-4, -6, -2, -6, 0, 1, 2, 3, 4, 5]
        matrices(4, 6, :10) = [-5, -5, -3, -5, -1, 0, 4, 3, 2, 1]
        matrices(4, 7, :10) = [-6, -4, -4, -4, -2, -4, 0, 1, 2, 3]
        matrices(4, 8, :10) = [-7, -3, -5, -3, -3, -3, -1, 0, 2, 1]
        matrices(4, 9, :10) = [-8, -2, -6, -2, -4, -2, -2, -2, 0, 1]
        matrices(4, 10, :10) = [-9, -1, -7, -1, -5, -1, -3, -1, -1, 0]
    end subroutine initialize_test_matrices

    subroutine print_matrix(matrix, n)
        integer, intent(in) :: n
        integer, intent(in) :: matrix(MAX_SIZE, MAX_SIZE)
        integer :: i, j

        do i = 1, n
            write(*, '(A)', advance='no') '|'
            do j = 1, n-1
                write(*, '(I3, A)', advance='no') matrix(i, j), ', '
            end do
            write(*, '(I3, A)') matrix(i, n), '|'
        end do
    end subroutine print_matrix

    function factorial(n) result(fact)
        integer, intent(in) :: n
        integer :: fact
        integer :: i

        fact = 1
        do i = 2, n
            fact = fact * i
        end do
    end function factorial

    function is_antisymmetric(matrix, n) result(antisym)
        integer, intent(in) :: n
        integer, intent(in) :: matrix(MAX_SIZE, MAX_SIZE)
        logical :: antisym
        integer :: i, j

        antisym = .true.

        ! Check diagonal is zero
        do i = 1, n
            if (matrix(i, i) /= 0) then
                antisym = .false.
                return
            end if
        end do

        ! Check antisymmetry: A(i,j) = -A(j,i)
        do i = 1, n
            do j = i+1, n
                if (matrix(i, j) /= -matrix(j, i)) then
                    antisym = .false.
                    return
                end if
            end do
        end do
    end function is_antisymmetric

    subroutine generate_signed_permutations(n, signed_perms, num_perms)
        integer, intent(in) :: n
        type(signed_perm), intent(out) :: signed_perms(MAX_FACTORIAL)
        integer, intent(out) :: num_perms
        integer :: perms(MAX_SIZE)
        integer :: sign, i, j, k, temp
        integer :: fact_n

        ! Initialize first permutation
        do i = 1, n
            perms(i) = i - 1  ! 0-based indexing like C++
        end do

        signed_perms(1)%permutation(1:n) = perms(1:n)
        signed_perms(1)%sign = 1
        sign = 1
        num_perms = 1
        fact_n = factorial(n)

        ! Generate all permutations using lexicographic algorithm
        do k = 2, fact_n
            ! Find largest index i such that perms(i) < perms(i+1)
            i = n - 1
            do while (i >= 1 .and. perms(i) >= perms(i+1))
                i = i - 1
            end do

            if (i == 0) exit  ! No more permutations

            ! Find largest index j such that perms(i) < perms(j)
            j = n
            do while (perms(j) <= perms(i))
                j = j - 1
            end do

            ! Swap perms(i) and perms(j)
            temp = perms(i)
            perms(i) = perms(j)
            perms(j) = temp
            sign = -sign

            ! Reverse the suffix starting at perms(i+1)
            i = i + 1
            j = n
            do while (i < j)
                temp = perms(i)
                perms(i) = perms(j)
                perms(j) = temp
                sign = -sign
                i = i + 1
                j = j - 1
            end do

            num_perms = num_perms + 1
            signed_perms(num_perms)%permutation(1:n) = perms(1:n)
            signed_perms(num_perms)%sign = sign
        end do
    end subroutine generate_signed_permutations

    subroutine compute_faffian(matrix, n, faffian_type, result, valid)
        integer, intent(in) :: n, faffian_type
        integer, intent(in) :: matrix(MAX_SIZE, MAX_SIZE)
        integer, intent(out) :: result
        logical, intent(out) :: valid

        type(signed_perm) :: signed_perms(MAX_FACTORIAL)
        integer :: num_perms, half_n, i, j, perm_idx
        integer :: sum_val, product, sign_val
        real :: normalization

        valid = .false.

        ! Check if matrix size is even
        if (mod(n, 2) /= 0) then
            if (faffian_type == PFAFFIAN) then
                write(*, *) 'Matrix size must be even for Pfaffian'
            else
                write(*, *) 'Matrix size must be even for Hfaffain'
            end if
            return
        end if

        ! Check if matrix is antisymmetric
        if (.not. is_antisymmetric(matrix, n)) then
            if (faffian_type == PFAFFIAN) then
                write(*, *) 'The Pfaffian does not support non-antisymmetric matrices'
            else
                write(*, *) 'The Hfaffain does not support non-antisymmetric matrices'
            end if
            return
        end if

        half_n = n / 2
        sum_val = 0

        ! Generate all permutations of n elements
        call generate_signed_permutations(n, signed_perms, num_perms)

        ! Sum over all permutations
        do perm_idx = 1, num_perms
            if (faffian_type == PFAFFIAN) then
                sign_val = signed_perms(perm_idx)%sign
            else
                sign_val = 1  ! Hfaffian ignores sign
            end if

            product = 1
            do i = 1, half_n
                ! Convert from 0-based to 1-based indexing
                j = 2 * i - 1
                product = product * matrix(signed_perms(perm_idx)%permutation(j) + 1, &
                                         signed_perms(perm_idx)%permutation(j + 1) + 1)
            end do

            sum_val = sum_val + sign_val * product
        end do

        ! Apply normalization
        normalization = 1.0 / factorial(half_n) / (2.0 ** half_n)
        result = nint(sum_val * normalization)
        valid = .true.
    end subroutine compute_faffian

end program pfaffian_calculator
