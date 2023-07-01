program remove_dups
    implicit none
    integer :: example(12)         ! The input
    integer :: res(size(example))  ! The output
    integer :: k                   ! The number of unique elements
    integer :: i

    example = [1, 2, 3, 2, 2, 4, 5, 5, 4, 6, 6, 5]
    k = 1
    res(1) = example(1)
    do i=2,size(example)
        ! if the number already exist in res check next
        if (any( res == example(i) )) cycle
        ! No match found so add it to the output
        k = k + 1
        res(k) = example(i)
    end do

    write(*,advance='no',fmt='(a,i0,a)') 'Unique list has ',k,' elements: '
    write(*,*) res(1:k)
end program remove_dups
