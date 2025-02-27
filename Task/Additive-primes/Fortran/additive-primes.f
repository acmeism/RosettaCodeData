program AdditivePrimes
      implicit none

      integer :: i, j, digit_sum, count
      logical :: is_prime

      ! Arrays to track prime numbers and additive primes
      logical, dimension(500) :: prime_check
      logical, dimension(500) :: additive_prime_check

      ! Initialize arrays
      prime_check = .true.
      prime_check(1) = .false.
      additive_prime_check = .false.

      ! Sieve of Eratosthenes to find primes
      do i = 2, int(sqrt(real(500)))
        if (prime_check(i)) then
          do j = i*i, 500, i
            prime_check(j) = .false.
          end do
        end if
      end do

      ! Find additive primes
      count = 0
      do i = 2, 500
        if (prime_check(i)) then
          ! Calculate digit sum
          digit_sum = sum_digits(i)

          ! Check if digit sum is also prime
          if (prime_check(digit_sum)) then
            additive_prime_check(i) = .true.
            count = count + 1
          end if
        end if
      end do

      ! Print results
      print *, "Additive Primes less than 500:"
      do i = 2, 500
        if (additive_prime_check(i)) then
          print *, i
        end if
      end do

      print *, "Total number of additive primes:", count

      contains

      ! Function to calculate sum of digits
      function sum_digits(num) result(total)
        integer, intent(in) :: num
        integer :: total, temp_num

        total = 0
        temp_num = num

        do while (temp_num > 0)
          total = total + mod(temp_num, 10)
          temp_num = temp_num / 10
        end do
      end function sum_digits

      end program AdditivePrimes
