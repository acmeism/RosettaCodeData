!-*- mode: compilation; default-directory: "/tmp/" -*-
!Compilation started at Mon Jun  3 11:18:24
!
!a=./f && make FFLAGS='-O0 -g' $a && OMP_NUM_THREADS=2 $a < unixdict.txt
!gfortran -std=f2008 -O0 -g -Wall -fopenmp -ffree-form -fall-intrinsics -fimplicit-none f.f08 -o f
! Original and flag sequences
! WHITE RED   blue  blue  RED   WHITE WHITE WHITE blue  RED   RED   blue
! RED   RED   RED   RED   WHITE WHITE WHITE WHITE blue  blue  blue  blue
!          12 items,           8  swaps.
!         999 items,         666  swaps.
!        9999 items,        6666  swaps.
!
!Compilation finished at Mon Jun  3 11:18:24

program Netherlands

  character(len=6), parameter, dimension(3) :: colors = (/'RED   ', 'WHITE ', 'blue  '/)
  integer, dimension(12) :: sort_me
  integer, dimension(999), target :: a999
  integer, dimension(9999), target :: a9999
  integer, dimension(:), pointer  :: pi
  integer :: i, swaps
  data sort_me/4*1,4*2,4*3/
  call shuffle(sort_me, 5)
  write(6,*)'Original and flag sequences'
  write(6,*) (colors(sort_me(i)), i = 1, size(sort_me))
  call partition3way(sort_me, 2, swaps)
  write(6,*) (colors(sort_me(i)), i = 1, size(sort_me))
  write(6,*) 12,'items,',swaps,' swaps.'
  pi => a999
  do i=1, size(pi)
    pi(i) = 1 + L(size(pi)/3 .lt. i) + L(2*size(pi)/3 .lt. i)
  end do
  call shuffle(pi, size(pi)/3+1)
  call partition3way(pi, 2, swaps)
  write(6,*) size(pi),'items,',swaps,' swaps.'
  pi => a9999
  do i=1, size(pi)
    pi(i) = 1 + L(size(pi)/3 .lt. i) + L(2*size(pi)/3 .lt. i)
  end do
  call shuffle(pi, size(pi)/3+1)
  call partition3way(pi, 2, swaps)
  write(6,*) size(pi),'items,',swaps,' swaps.'

contains

  integer function L(q)
    ! In Ken Iverson's spirit, APL logicals are more useful as integers.
    logical, intent(in) :: q
    if (q) then
      L = 1
    else
      L = 0
    end if
  end function L

  subroutine swap(a,i,j)
    integer, dimension(:), intent(inout) :: a
    integer, intent(in) :: i, j
    integer :: t
    t = a(i)
    a(i) = a(j)
    a(j) = t
  end subroutine swap

  subroutine partition3way(a, pivot, swaps)
    integer, dimension(:), intent(inout) :: a
    integer, intent(in) :: pivot
    integer, intent(out) :: swaps
    integer :: i, j, k
    swaps = 0
    i = 0
    j = 1
    k = size(a) + 1
    do while (j .lt. k)
      if (pivot .eq. a(j)) then
        j = j+1
        swaps = swaps-1
      else if (pivot .lt. a(j)) then
        k = k-1
        call swap(a, k, j)
      else
        i = i+1
        call swap(a, i, j)
        j = j+1
      end if
      swaps = swaps+1
    end do
  end subroutine partition3way

  subroutine shuffle(a, n) ! a rather specialized shuffle not for general use
    integer, intent(inout), dimension(:) :: a
    integer, intent(in) :: n
    integer :: i, j, k
    real :: harvest
    do i=1, size(a)-1
      call random_number(harvest)
      harvest = harvest - epsilon(harvest)*L(harvest.eq.1)
      k = L(i.eq.1)*(n-1) + i
      j = i + int((size(a) - k) * harvest)
      call swap(a, i, j)
    end do
  end subroutine shuffle

end program Netherlands
