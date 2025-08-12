program totient_function
    implicit none
    integer, parameter :: M = 100000
    integer :: i, j
    integer, dimension(1:M) :: phi
    character(len=10) :: is_prime
    integer :: count100, count1000, count10000, count100000

    ! Initialize phi array
    do i = 1, M
        phi(i) = i
    end do

    ! Compute totient using sieve method
    do i = 2, M
        if (phi(i) == i) then  ! i is prime
            do j = i, M, i
                phi(j) = (phi(j) / i) * (i - 1)
            end do
        end if
    end do

    ! Display for the first 25 integers
    print*,'n        phi       prime'
    print*,repeat('-',30)
    do i = 1, 25
        if (phi(i) == i - 1) then
            is_prime = 'prime'
        else
            is_prime = 'not prime'
        end if
        print "(i0,t10,i3,t20,a)", i, phi(i), trim(is_prime)
    end do

    ! Count primes up to specified limits
    count100 = 0
    count1000 = 0
    count10000 = 0
    count100000 = 0
    do i = 2, M
        if (phi(i) == i - 1) then
            if (i <= 100) count100 = count100 + 1
            if (i <= 1000) count1000 = count1000 + 1
            if (i <= 10000) count10000 = count10000 + 1
            count100000 = count100000 + 1
        end if
    end do

    print *, 'Count of primes up to 100:', count100
    print *, 'Count of primes up to 1,000:', count1000
    print *, 'Count of primes up to 10,000:', count10000
    print *, 'Count of primes up to 100,000:', count100000

end program totient_function
