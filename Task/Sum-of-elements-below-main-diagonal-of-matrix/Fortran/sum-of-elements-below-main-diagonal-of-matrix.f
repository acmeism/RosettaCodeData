program sum_below_diagonal
    implicit none
    integer, dimension(5,5) :: matrix
    integer :: i, j, total_sum

    ! Initialize the matrix
    matrix = reshape([1, 2, 3, 12, 7, &
                      3, 4, 1, 14, 1, &
                      7, 16, 9, 17, 3, &
                      8, 14, 18, 18, 9, &
                      10, 4, 11, 20, 5], shape(matrix), order=[1,2])

    ! Compute the sum of elements below the main diagonal
    total_sum = 0
    do i = 1, 5
        do j = 1, 5
            if (i > j) then
                total_sum = total_sum + matrix(i, j)
            end if
        end do
    end do

    ! Display the sum
    print *, "The sum of elements below the main diagonal is: ", total_sum

end program sum_below_diagonal
.
