program Constrained_Points
  implicit none

  integer, parameter :: samples = 100
  integer :: i, j, n, randpoint
  real :: r

  type points
    integer :: x, y
  end type

  type(points) :: set(500), temp

! Create set of valid points
  n = 0
  do i = -15, 15
    do j = -15, 15
      if(sqrt(real(i*i + j*j)) >= 10.0 .and. sqrt(real(i*i + j*j)) <= 15.0) then
        n = n + 1
        set(n)%x = i
        set(n)%y = j
      end if
    end do
  end do

! create 100 random points
! Choose a random number between 1 and n inclusive and swap point at this index with point at index 1
! Choose a random number between 2 and n inclusive and swap point at this index with point at index 2
! Continue in this fashion until 100 points have been selected
  call random_seed
  do i = 1, samples
    call random_number(r)
    randpoint = r * (n + 1 - i) + i
    temp = set(i)
    set(i) = set(randpoint)
    set(randpoint) = temp
  end do

! In order to facilitate printing sort random points into ascending order
! sort x in ascending order
  do i = 2, samples
     j = i - 1
     temp = set(i)
        do while (j>=1 .and. set(j)%x > temp%x)
           set(j+1) = set(j)
           j = j - 1
        end do
     set(j+1) = temp
  end do

! sort y in ascending order for same x
  do i = 2, samples
     j = i - 1
     temp = set(i)
        do while (j>=1 .and. set(j)%x == temp%x .and. set(j)%y > temp%y)
           set(j+1) = set(j)
           j = j - 1
        end do
     set(j+1) = temp
  end do

! print circle
  write(*,"(a,a)", advance="no") repeat(" ", set(1)%y+15), "*"
  do i = 2, samples
    if(set(i)%x == set(i-1)%x) then
      write(*,"(a,a)", advance="no") repeat(" ", set(i)%y - set(i-1)%y-1), "*"
    else
      n = set(i)%x - set(i-1)%x
      do j = 1, n
        write(*,*)
      end do
      write(*,"(a,a)", advance="no") repeat(" ", set(i)%y+15), "*"
    end if
  end do

end program
