program josephus
   implicit none

   integer :: n, k, m, i, pq
   integer, allocatable :: seq(:)
   integer :: ios

   ! --- Verify with the n=5, k=2 example from the problem ---
   n = 5;  k = 2
   allocate(seq(n))
   call josephus_sequence(n, , k, seq)
   write(*, '(a)') 'Verification: n=5, k=2'
   write(*, '(2x,a)', advance='no') 'Kill order: '
   do i = 1, n - 1
      write(*, '(i0,a)', advance='no') seq(i), ' '
   end do
   write(*, '(a,i0)') '  survivor: #', seq(n)
   deallocate(seq)

   ! --- Classic Josephus: n=41, k=3 ---
   n = 41;  k = 3
   allocate(seq(n))
   call josephus_sequence(n, k, seq)
   write(*, '(/a)') 'Josephus problem: n=41, k=3'
   write(*, '(2x,a,i0)') 'Josephus survived as prisoner #', seq(n)
   write(*, '(2x,a)') 'Full killing sequence:'
   do i = 1, n - 1
      write(*, '(4x,a,i0,a,i0)') 'step ', i, ':  prisoner #', seq(i)
   end do
   deallocate(seq)

   ! --- Interactive mode ---
   write(*, '(/a)') 'Interactive: enter  n  k  m  (m = survivors; n=0 to quit)'
   do
      read(*, *, iostat=ios) n, k, m
      if (ios /= 0 .or. n <= 0) exit
      if (k <= 0 .or. m < 1 .or. m > n) then
         write(*, '(2x,a)') 'Invalid input: need k>0, 1<=m<=n'
         cycle
      end if

      allocate(seq(n))
      call josephus_sequence(n, k, seq)

      if (m == 1) then
         write(*, '(2x,a,i0,a,i0,a,i0)') &
            'n=', n, '  k=', k, ':  survivor is prisoner #', seq(n)
      else
         write(*, '(2x,a,i0,a,i0,a,i0,a)') &
            'n=', n, '  k=', k, ':  ', m, ' survivors (in rescue order):'
         do i = n - m + 1, n
            write(*, '(4x,a,i0)') 'prisoner #', seq(i)
         end do
      end if

      write(*, '(2x,a,i0,a)') 'Kill sequence (', n - m, ' killed):'
      do i = 1, n - m
         write(*, '(4x,a,i0,a,i0)') 'step ', i, ':  prisoner #', seq(i)
      end do

      write(*, '(2x,a)', advance='no') &
         'Query position in sequence (0 to skip): '
      read(*, *, iostat=ios) pq
      if (ios == 0 .and. pq >= 1 .and. pq <= n) then
         write(*, '(4x,a,i0,a,i0)') &
            'Position ', pq, ' in sequence: prisoner #', seq(pq)
      end if

      deallocate(seq)
   end do

contains

   ! Build the full Josephus sequence for n prisoners, step k.
   ! killed(1) = first prisoner executed, killed(n) = sole survivor.
   ! For m survivors, the freed prisoners are killed(n-m+1) .. killed(n).
   subroutine josephus_sequence(n, k, killed)
      integer, intent(in)  :: n, k
      integer, intent(out) :: killed(n)
      integer :: circle(n), alive, pos, i

      do i = 1, n
         circle(i) = i - 1     ! prisoners numbered 0 .. n-1
      end do

      alive = n
      pos   = 1                ! 1-indexed position in the shrinking circle

      do i = 1, n
         ! Advance k-1 more steps from current pos (wrapping); that is the target
         pos       = mod(pos + k - 2, alive) + 1
         killed(i) = circle(pos)
         ! Remove the killed prisoner by compacting the array
         if (pos < alive) circle(pos:alive - 1) = circle(pos + 1:alive)
         alive = alive - 1
         if (alive > 0 .and. pos > alive) pos = 1
      end do
   end subroutine josephus_sequence

end program josephus
