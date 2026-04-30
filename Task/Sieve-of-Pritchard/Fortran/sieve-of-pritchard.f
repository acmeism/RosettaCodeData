program sieve_pritchard_optimized
   implicit none

   call test_pritchard()

contains

   function pritchard(limit, verbose) result(all_primes)
      integer, intent(in) :: limit
      logical, intent(in) :: verbose
      integer, allocatable :: all_primes(:)

      logical, allocatable :: members(:), mcopy(:)
      integer, allocatable :: primes(:)
      integer :: steplength, prime, nlimit, rtlim
      integer :: w, n, np
      integer :: prime_count, i, total_count, ac, rc

      ! Allocate arrays
      allocate(members(limit))
      members = .false.
      members(1) = .true.
      allocate(mcopy(limit))
      i = limit/log(float(limit)) + (limit/log(float(limit)))/2 ! Estimate the number of primes
      allocate(primes(i))  ! Upper bound for primes
      prime_count = 0

      steplength = 1
      prime = 2
      nlimit = prime * steplength
      ac = 2
      rc = 1
      rtlim = int(sqrt(real(limit)))

      do while (prime < rtlim)
         ! Step 1: Roll wheel
         if (steplength < limit) then
            do w = 1, steplength
               if (members(w)) then
                  n = w + steplength
                  do while (n <= nlimit)
                     members(n) = .true.
                     ac = ac + 1
                     n = n + steplength
                  end do
               end if
            end do
            steplength = nlimit
         end if

         ! Step 2: Mark multiples using a copy of current wheel
         mcopy = members
         np = 5
         do w = 1, nlimit
            if (mcopy(w)) then
               if (np == 5 .and. w > prime) np = w
               n = prime * w
               if (n > nlimit) exit
               rc = rc + 1
               members(n) = .false.
            end if
         end do

         if (np < prime) exit

         ! Store current prime
         prime_count = prime_count + 1
         primes(prime_count) = prime

         ! Update prime and nlimit
         prime = merge(3, np, prime == 2)
         nlimit = min(steplength * prime, limit)
      end do

      members(1) = .false.

      ! Count remaining primes in wheel
      total_count = prime_count
      do i = 1, limit
         if (members(i)) total_count = total_count + 1
      end do

      ! Allocate final primes array
      allocate(all_primes(total_count))
      all_primes(1:prime_count) = primes(1:prime_count)

      ! Append remaining primes
      total_count = prime_count
      do i = 1, limit
         if (members(i)) then
            total_count = total_count + 1
            all_primes(total_count) = i
         end if
      end do

      if (verbose) then
         print '(a,i0,a,i0,a,i0,a,i0)', &
            "up to ", limit, ", added ", ac, ", removed ", rc, &
            ", prime count ", size(all_primes)
      end if

      deallocate(members, mcopy, primes)
   end function pritchard

   subroutine test_pritchard()
      integer, allocatable :: result(:)
      integer :: i

      ! All primes <= 150
      result = pritchard(150, .false.)
      do i = 1, size(result)
         write(*,'(i0,1x)',advance='no') result(i)
      end do
      print *

      deallocate(result)

      ! Number of primes <= 1,000,000
      result = pritchard(1000000, .true.)
      deallocate(result)
   end subroutine test_pritchard

end program sieve_pritchard_optimized
