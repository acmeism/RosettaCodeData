      program Mertens
      implicit none
      integer M(1000), n, k, zero, cross

C     Generate Mertens numbers
      M(1) = 1
      do 10 n=2, 1000
          M(n) = 1
          do 10 k=2, n
              M(n) = M(n) - M(n/k)
 10   continue

C     Print table
      write (*,"('The first 99 Mertens numbers are:')")
      write (*,"('   ')",advance='no')
      k = 9
      do 20 n=1, 99
          write (*,'(I3)',advance='no') M(n)
          k = k-1
          if (k .EQ. 0) then
              k=10
              write (*,*)
          end if
 20   continue

C     Calculate zeroes and crossings
      zero = 0
      cross = 0
      do 30 n=2, 1000
          if (M(n) .EQ. 0) then
              zero = zero + 1
              if (M(n-1) .NE. 0) cross = cross+1
          end if
 30   continue

 40   format("M(N) is zero ",I2," times.")
      write (*,40) zero
 50   format("M(N) crosses zero ",I2," times.")
      write (*,50) cross
      end program
