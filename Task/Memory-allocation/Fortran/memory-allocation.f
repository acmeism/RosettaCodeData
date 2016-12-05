program allocation_test
    implicit none
    real, dimension(:), allocatable :: vector
    real, dimension(:, :), allocatable :: matrix
    real, pointer :: ptr
    integer, parameter :: n = 100 ! Size to allocate

    allocate(vector(n))      ! Allocate a vector
    allocate(matrix(n, n))   ! Allocate a matrix
    allocate(ptr)            ! Allocate a pointer

    deallocate(vector)       ! Deallocate a vector
    deallocate(matrix)       ! Deallocate a matrix
    deallocate(ptr)          ! Deallocate a pointer
end program allocation_test
