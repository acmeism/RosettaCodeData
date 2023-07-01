! Ascending primes
!
! Generate and show all primes with strictly ascending decimal digits.
!
!
! Solution
!
! We only consider positive numbers in the range 1 to 123456789. We would get
! 7027260 primes, because there are so many primes smaller than 123456789 (see
! also Wolfram Alpha). On the other hand, there are only 511 distinct positive
! integers having their digits arranged in ascending order. Therefore, it is
! better to start with numbers that have properly arranged digits and then check
! if they are prime numbers. The method of generating a sequence of such numbers
! is not indifferent. We want this sequence to be monotonically increasing,
! because then additional sorting of results will be unnecessary. It turns out
! that by using a queue we can easily get the desired effect. Additionally, the
! algorithm then does not use recursion (although the program probably does not
! have to comply with the MISRA standard). The problem to be solved is the queue
! size, the a priori assumption that 1000 is good enough, but a bit magical.


program prog

    parameter (MAXSIZE = 1000)

    logical isprime
    dimension iqueue(MAXSIZE)
    dimension iprimes(MAXSIZE)

    ibegin = 1
    iend = 1
    n = 0

    do k = 1, 9
        iqueue(iend) = k
        iend = iend + 1
    end do

    do while (ibegin .lt. iend)
        iv = iqueue(ibegin)
        ibegin = ibegin + 1
        if (isprime(iv)) then
            n = n + 1
            iprimes(n) = iv
        end if
        lsd1 = mod(iv, 10) + 1
        if (lsd1 .le. 9) then
            do k = lsd1, 9
                iqueue(iend) = iv * 10 + k
                iend = iend + 1
            end do
        end if
    end do

    print *, (iprimes(i), i = 1, n)

end program


logical function isprime(n)

! Slightly improved algorithm for checking if a number is prime.
! First, we check the special cases: 0, 1, 2. Then we check whether
! the number is divisible by 2. If it is not divisible by two,
! we check whether it is divisible by odd numbers not greater than
! the square root of that number.
!
! Positive numbers only. BTW, negative numbers are prime numbers
! if their absolute values are prime numbers.

    isprime = .FALSE.
    if (n .eq. 0 .or. n .eq. 1) then
        return
    end if
    if (n .ne. 2) then
        if (mod(n, 2) .eq. 0) then
            return
        end if
        m = n**0.5
        do k = 3, m, 2
            if (mod(n, k) .eq. 0) then
                return
            end if
        end do
    end if
    isprime = .TRUE.
end function
