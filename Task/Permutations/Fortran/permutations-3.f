   program testing_permutation_algorithms

   implicit none
   integer :: nmax
   integer, dimension(:),allocatable :: ida
   logical :: mtc
   logical :: even
   integer :: i
   integer(8) :: ic
   integer :: clock_rate, clock_max, t1, t2
   real(8) :: dt
   integer :: pos_min, pos_max
!
!
!  Beginning:
!
   write(*,*) 'INPUT N:'
   read *, nmax
   write(*,*) 'N =', nmax
   allocate ( ida(1:nmax) )
!
!
!  (1) Starting:
!
   do i  =  1, nmax
      ida(i) = i
   enddo
!
   ic = 0
   call system_clock ( t1, clock_rate, clock_max )
!
   mtc = .false.
!
   do
      call subnexper ( nmax, ida, mtc, even )
!
!     1) counting the number of permutatations
!
      ic = ic + 1
!
!     2) writing out the result:
!
!     do i  =  1, nmax
!        write (100,"(i3,',')",advance = "no") ida(i)
!     enddo
!     write(100,*)
!
!     repeat if not being finished yet, otherwise exit.
!
      if (mtc) then
         cycle
      else
         exit
      endif
!
   enddo
!
   call system_clock ( t2, clock_rate, clock_max )
   dt =  ( dble(t2) - dble(t1) )/ dble(clock_rate)
!
!  Finishing (1)
!
   write(*,*) "1) subnexper:"
   write(*,*) 'Total permutations :', ic
   write(*,*) 'Total time elapsed :', dt
!
!
!  (2) Starting:
!
   do i  =  1, nmax
      ida(i) = i
   enddo
!
   pos_min = 1
   pos_max = nmax
!
   ic = 0
   call system_clock ( t1, clock_rate, clock_max )
!
   call generate ( pos_min )
!
   call system_clock ( t2, clock_rate, clock_max )
   dt =  ( dble(t2) - dble(t1) )/ dble(clock_rate)
!
!  Finishing (2)
!
   write(*,*) "2) generate:"
   write(*,*) 'Total permutations :', ic
   write(*,*) 'Total time elapsed :', dt
!
!
!  (3) Starting:
!
   do i  =  1, nmax
      ida(i) = i
   enddo
!
   ic = 0
   call system_clock ( t1, clock_rate, clock_max )
!
   i = 1
   call perm ( i )
!
   call system_clock ( t2, clock_rate, clock_max )
   dt =  ( dble(t2) - dble(t1) )/ dble(clock_rate)
!
!  Finishing (3)
!
   write(*,*) "3) perm:"
   write(*,*) 'Total permutations :', ic
   write(*,*) 'Total time elapsed :', dt
!
!
!  (4) Starting:
!
   do i  =  1, nmax
      ida(i) = i
   enddo
!
   ic = 0
   call system_clock ( t1, clock_rate, clock_max )
!
   do
!
!     1) counting the number of permutatations
!
      ic = ic + 1
!
!     2) writing out the result:
!
!     do i  =  1, nmax
!        write (100,"(i3,',')",advance = "no") ida(i)
!     enddo
!     write(100,*)
!
!     repeat if not being finished yet, otherwise exit.
!
      if ( nextp(nmax,ida) ) then
         cycle
      else
         exit
      endif
!
   enddo
!
   call system_clock ( t2, clock_rate, clock_max )
   dt =  ( dble(t2) - dble(t1) )/ dble(clock_rate)
!
!  Finishing (4)
!
   write(*,*) "4) nextp:"
   write(*,*) 'Total permutations :', ic
   write(*,*) 'Total time elapsed :', dt
!
!
!  What's else?
!  ...
!
!==
   deallocate(ida)
!
   stop
!==
   contains
!==
!     Modified version of SUBROUTINE NEXPER from the book of
!     Albert Nijenhuis and Herbert S. Wilf, "Combinatorial
!     Algorithms For Computers and Calculators", 2nd Ed, p.59.
!
      subroutine subnexper ( n, a, mtc, even )
      implicit none
      integer,intent(in)    ::  n
      integer,dimension(n),intent(inout)  :: a
      logical,intent(inout) :: mtc, even
!
!     local varialbes:
!
      integer,save :: nm3
      integer :: ia, i, s, d, i1, l, j, m
!
      if (mtc) goto 10

      nm3 = n-3

      do i = 1,n
         a(i) = i
      enddo

      mtc  = .true.
5     even = .true.

      if ( n .eq. 1 ) goto 8

6     if ( a(n) .ne. 1 .or. a(1) .ne. 2+mod(n,2) ) return

      if ( n .le. 3 ) goto 8

      do i = 1,nm3
         if( a(i+1) .ne. a(i)+1 ) return
      enddo

8     mtc = .false.

      return

10    if ( n .eq. 1 ) goto 27

      if( .not. even ) goto 20

      ia   = a(1)
      a(1) = a(2)
      a(2) = ia
      even = .false.

      goto 6

20    s = 0

      do i1 = 2,n
         ia = a(i1)
         i = i1-1
         d = 0
         do j = 1,i
            if ( a(j) .gt. ia ) d = d+1
         enddo
         s = d+s
         if ( d .ne. i*mod(s,2) ) goto 35
      enddo

27    a(1) = 0

      goto 8

35    m = mod(s+1,2)*(n+1)

      do j = 1,i
         if(isign(1,a(j)-ia) .eq. isign(1,a(j)-m)) cycle
         m = a(j)
         l = j
      enddo

      a(l) = ia
      a(i1) = m
      even = .true.

      return
      end subroutine
!=====
!
!     http://rosettacode.org/wiki/Permutations#Fortran
!
      recursive subroutine generate (pos)

      implicit none
      integer,intent(in) :: pos
      integer :: val

      if (pos > pos_max) then
!
!        1) counting the number of permutatations
!
         ic = ic + 1
!
!        2) writing out the result:
!
!        write (*,*) permutation
!
      else
         do val = 1, nmax
            if (.not. any (ida( : pos-1) == val)) then
               ida(pos) = val
               call generate (pos + 1)
            endif
         enddo
      endif

      end subroutine
!=====
!
!     http://rosettacode.org/wiki/Permutations#Fortran
!
      recursive subroutine perm (i)
      implicit none
      integer,intent(inout) :: i
!
      integer :: j, t, ip1
!
      if (i == nmax) then
!
!        1) couting the number of permutatations
!
         ic = ic + 1
!
!        2) writing out the result:
!
!        write (*,*) a
!
      else
         ip1 = i+1
         do j = i, nmax
            t = ida(i)
            ida(i) = ida(j)
            ida(j) = t
            call perm ( ip1 )
            t = ida(i)
            ida(i) = ida(j)
            ida(j) = t
         enddo
      endif
      return
      end subroutine
!=====
!
!     http://rosettacode.org/wiki/Permutations#Fortran
!
      function nextp ( n, a )
      logical :: nextp
      integer,intent(in) :: n
      integer,dimension(n),intent(inout) :: a
!
!     local variables:
!
      integer i,j,k,t
!
      i = n-1
   10 if ( a(i) .lt. a(i+1) ) goto 20
      i = i-1
      if ( i .eq. 0 ) goto 20
      goto 10
   20 j = i+1
      k = n
   30 t = a(j)
      a(j) = a(k)
      a(k) = t
      j = j+1
      k = k-1
      if ( j .lt. k ) goto 30
      j = i
      if (j .ne. 0 ) goto 40
!
      nextp = .false.
!
      return
!
   40 j = j+1
      if ( a(j) .lt. a(i) ) goto 40
      t = a(i)
      a(i) = a(j)
      a(j) = t
!
      nextp = .true.
!
      return
      end function
!=====
!
!     What's else ?
!     ...

!=====
   end program
