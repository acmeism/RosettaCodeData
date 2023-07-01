! loosely translated from python.
! compilation: gfortran -Wall -std=f2008 thisfile.f08

!$ a=site && gfortran -o $a -g -O0 -Wall -std=f2008 $a.f08 && $a
!100 trials per
!Fill Fraction goal(%)    simulated through paths(%)
!           0                          0
!          10                          0
!          20                          0
!          30                          0
!          40                          0
!          50                          6
!
!
!    b b b   b   h   j     m m m
!  b b   b b b   h h   m m m m m
!    b b b       h h h     m
!    b     h h h   h h h h
!  b b   h h   h h h h   h h h
!  b b b   h h h   h h h h h h h
!  b b   @   h   h   h h h h h
!      @ @       h h h h h h h h
!    @ @ @ @       h h   h   h
!      @ @ @ @       h h h h h h
!      @ @ @   h h h h     h h h
!  @ @ @     h h   h   h     h h
!    @       h         h h h h h
!  @     h h   h     h h h     h
!  @ @   h h h h h h h   h h   h
!          60                         59
!          70                         97
!          80                        100
!          90                        100
!         100                        100

program percolation_site
  implicit none
  integer, parameter :: m=15,n=15,t=100
  !integer, parameter :: m=2,n=2,t=8
  integer(kind=1), dimension(m, n) :: grid
  real :: p
  integer :: i, ip, trial, successes
  logical :: success, unseen, q
  data unseen/.true./
  write(6,'(i3,a11)') t,' trials per'
  write(6,'(a21,a30)') 'Fill Fraction goal(%)','simulated through paths(%)'
  do ip=0, 10
     p = ip/10.0
     successes = 0
     do trial = 1, t
        call newgrid(grid, p)
        success = .false.
        do i=1, m
           q = walk(grid, i)    ! deliberately compute all paths
           success = success .or. q
        end do
        if ((ip == 6) .and. unseen) then
           call display(grid)
           unseen = .false.
        end if
        successes = successes + merge(1, 0, success)
     end do
     write(6,'(9x,i3,24x,i3)')ip*10,nint(100*real(successes)/real(t))
  end do

contains

  logical function walk(grid, start)
    integer(kind=1), dimension(m,n), intent(inout) :: grid
    integer, intent(in) :: start
    walk = rwalk(grid, 1, start, int(start+1,1))
  end function walk

  recursive function rwalk(grid, i, j, k) result(through)
    logical :: through
    integer(kind=1), dimension(m,n), intent(inout) :: grid
    integer, intent(in) :: i, j
    integer(kind=1), intent(in) :: k
    logical, dimension(4) :: q
    !out of bounds
    through = .false.
    if (i < 1) return
    if (m < i) return
    if (j < 1) return
    if (n < j) return
    !visited or non-pore
    if (1_1 /= grid(i, j)) return
    !update grid and recurse with neighbors.  deny 'shortcircuit' evaluation
    grid(i, j) = k
    q(1) = rwalk(grid,i+0,j+1,k)
    q(2) = rwalk(grid,i+0,j-1,k)
    q(3) = rwalk(grid,i+1,j+0,k)
    q(4) = rwalk(grid,i-1,j+0,k)
    !newly discovered outlet
    through = (i == m) .or. any(q)
  end function rwalk

  subroutine newgrid(grid, probability)
    implicit none
    real :: probability
    integer(kind=1), dimension(m,n), intent(out) :: grid
    real, dimension(m,n) :: harvest
    call random_number(harvest)
    grid = merge(1_1, 0_1, harvest < probability)
  end subroutine newgrid

  subroutine display(grid)
    integer(kind=1), dimension(m,n), intent(in) :: grid
    integer :: i, j, k, L
    character(len=n*2) :: lineout
    write(6,'(/)')
    lineout = ' '
    do i=1,m
       do j=1,n
          k = j+j
          L = grid(i,j)+1
          lineout(k:k) = ' @abcdefghijklmnopqrstuvwxyz'(L:L)
       end do
       write(6,*) lineout
    end do
  end subroutine display

end program percolation_site
