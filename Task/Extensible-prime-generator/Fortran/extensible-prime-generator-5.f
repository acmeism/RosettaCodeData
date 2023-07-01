* incremental Sieve of Eratosthenes based on the paper,
* "Two Compact Incremental Prime Sieves"

      SUBROUTINE nextprime(no init, p)
      IMPLICIT NONE
      INTEGER*2, SAVE, ALLOCATABLE :: sieve(:,:)
      INTEGER, SAVE :: r, s, pos, n, f1, f2, sz
      INTEGER i, j, d, next, p, f3
      LOGICAL no init, is prime

      IF (no init) GO TO 10
      IF (ALLOCATED(sieve)) DEALLOCATE(sieve)

* Each row in the sieve is a stack of 8 short integers. The
* stacks will never overflow since the product 2*3*5 ... *29
* (10 primes) exceeds a 32 bit integer. 2 is not stored in the sieve.

      ALLOCATE(sieve(8,3))
      sieve = reshape([(0_2, i = 1, 24)], shape(sieve))
      r = 3
      s = 9
      pos = 1
      sz = 1 ! sieve starts with size = 1
      f1 = 2 ! Fibonacci sequence for allocating new capacities
      f2 = 3 ! array starts with capacity 3
      n = 1
      p = 2  ! return our first prime
      RETURN

10    n = n + 2
      is prime = .true.
      IF (sieve(1, pos) .eq. 0) GO TO 20 ! n is non-smooth w.r.t sieve
      is prime = .false. ! element at sieve(pos) divides n
      DO 17, i = 1, 8

Clear the stack of divisors by moving them to the next multiple

         d = sieve(i, pos)
         IF (d .eq. 0) GO TO 20 ! stack is empty
         IF (d .lt. 0) d = d + 65536 ! correct storage overflow
         sieve(i, pos) = 0
         next = mod(pos + d - 1, sz) + 1

* Push divisor d on to the stack of the next multiple

         j = 1
12       IF (sieve(j, next) .eq. 0) GO TO 15
         j = j + 1
         GO TO 12
15       sieve(j, next) = d
17    CONTINUE

Check if n is square; if so, then add sieving prime and advance

20    IF (n .lt. s) GO TO 30
      IF (.not. is prime) GO TO 25
      is prime = .false. ! r = √s divides n
      next = mod(pos + r - 1, sz) + 1 ! however, r is prime, insert it.

      j = 1
22    IF (sieve(j, next) .eq. 0) GO TO 23
      j = j + 1
      GO TO 22
23    sieve(j, next) = r

25    r = r + 2
      s = r**2

Continue to the next array slot; grow the array by two when
* we get to the end to maintain the invariant size(sieve) > √n
* IF the size exceeds the array capacity, resize the arary.

30    pos = pos + 1
      IF (pos .le. sz) GO TO 40
      sz = sz + 2
      pos = 1

      IF (sz .le. f2) GO TO 40 ! so far, no need to grow
      f3 = f1 + f2
      f1 = f2
      f2 = f3
      sieve = reshape(sieve, [8, f2],
     &                pad = [(0_2, i = 1, 8*(f2 - f1))])

* Either return n back to the caller or circle back if n
* turned out to be composite.

40    IF (.not. is prime) GO TO 10
      p = n
      END SUBROUTINE
