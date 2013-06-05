program josephus
   implicit none
   integer :: n, i, k, p
   integer, allocatable :: next(:)
   read *, n, k
   allocate(next(0:n - 1))
   do i = 0, n - 2
      next(i) = i + 1
   end do
   next(n - 1) = 0
   p = 0
   do while(next(p) /= p)
      do i = 1, k - 2
         p = next(p)
      end do
      print *, "Kill", next(p)
      next(p) = next(next(p))
      p = next(p)
   end do
   print *, "Alive", p
   deallocate(next)
end program
