program pathfinding
   implicit none

   ! Shared variables with zero-based indexing
   integer, dimension(0:7, 0:1) :: neighbours
   integer :: cnt
   integer :: pwid
   integer :: phei
   integer, dimension(:, :), allocatable :: pa
   integer :: t1, t2, rate

   ! Main program
   character(len=42) :: pz
   logical :: r
   ! Initialize neighbours array
   neighbours = reshape([ 2, 2, -2, 2, 2, -2, -2, -2, 3, 0, 0, 3, -3, 0, 0, -3 ], [8, 2], order=[2, 1])
   !Dim Shared As Integer neighbours(7, 1) => {{2, 2}, {-2, 2}, {2, -2}, {-2, -2}, {3, 0}, {0, 3}, {-3, 0}, {0, -3}}
   call system_clock(t1, rate)
   pz = '011011011111111111111011111000111000001000'
   r = solve(pz, 7, 6)
   call system_clock(t2)
   if (r) then
      call printsolution(7, 6)
   else
      print *, 'No solution!'
   end if
   call system_clock(t2)

   print '(A,1x,i0,1x,A)', 'Time taken =', t2 - t1, 'milliseconds'

contains

   function isvalid(a, b) result(res)
      integer, intent(in) :: a, b
      logical :: res
      res = (a > -1 .and. a < pwid .and. b > -1 .and. b < phei)
   end function isvalid

   recursive function iterate(pa, x, y, v) result(res)
      integer, dimension(0:, 0:), intent(inout) :: pa
      integer, intent(in) :: x, y, v
      integer :: res
      integer :: i, a, b, r

      if (v > cnt) then
         res = 1
         return
      end if

      res = 0
      do i = 0, 7
         a = x + neighbours(i, 0)
         b = y + neighbours(i, 1)
         if (isvalid(a, b))then
            if (pa(a, b) /= 0) cycle
            pa(a, b) = v
            r = iterate(pa, a, b, v + 1)
            if (r == 1) then
               res = r
               return
            end if
            pa(a, b) = 0
         end if
      end do
   end function iterate

   function solve(pz, w, h) result(res)
      character(len=*), intent(in) :: pz
      integer, intent(in) :: w, h
      logical :: res
      integer :: f, x, y

      ! Allocate and initialize pa array (zero-based indexing)
      if (allocated(pa)) deallocate(pa)
      allocate(pa(0:w - 1, 0:h - 1))
      pa = 0
      cnt = 0
      pwid = w
      phei = h
      f = 0

      ! Initialize the grid
      do y = 0, h - 1
         do x = 0, w - 1
            if (pz(f + 1:f + 1) == '1') then
               pa(x, y) = 0
               cnt = cnt + 1
            else
               pa(x, y) = -1
            end if
            f = f + 1
         end do
      end do

      ! Try to find a solution
      res = .false.
      do y = 0, h - 1
         do x = 0, w - 1
            if (pa(x, y) == 0) then
               pa(x, y) = 1
               if (iterate(pa, x, y, 2) == 1) then
                  res = .true.
                  return
               end if
               pa(x, y) = 0
            end if
         end do
      end do
   end function solve

   subroutine printsolution(w, h)
      integer, intent(in) :: w, h
      integer :: i, j
      character(len=3) :: fmt

      do j = 0, h - 1
         do i = 0, w - 1
            if (pa(i, j) == -1) then
               write(*, '(A)', advance='no') '   '
            else
               write(fmt, '(I2.2)') pa(i, j)
               write(*, '(A)', advance='no') adjustl(fmt)
            end if
         end do
         write(*,*)
      end do
   end subroutine printsolution

end program pathfinding
