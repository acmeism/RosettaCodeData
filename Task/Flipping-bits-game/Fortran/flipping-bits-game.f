!Implemented by Anant Dixit (October 2014)
program flipping_bits
implicit none
character(len=*), parameter :: cfmt = "(A3)", ifmt = "(I3)"
integer :: N, i, j, io, seed(8), moves, input
logical, allocatable :: Brd(:,:), Trgt(:,:)
logical :: solved
double precision :: r

do
  write(*,*) 'Enter the number of squares (between 1 and 10) you would like: '
  read(*,*,iostat=io) N
  if(N.gt.0 .and. N.le.10 .and. io.eq.0) exit
  write(*,*) 'Please, an integer between 1 and 10'
end do

allocate(Brd(N,N),Trgt(N,N))
call date_and_time(values=seed)
call srand(1000*seed(7)+seed(8)+60000*seed(6))
do i = 1,N
  do j = 1,N
    r = rand()
    if(r.gt.0.5D0) then
      Brd(i,j) = .TRUE.
      Trgt(i,j) = .TRUE.
    else
      Brd(i,j) = .FALSE.
      Trgt(i,j) = .FALSE.
    end if
  end do
end do
! Random moves taken by the program to `create' a target
moves = N
do i = 1,moves
  r = 1+2.0D0*dble(N)*rand() - 1.0D-17 !Only to make sure that the number is between 1 and 2N (less than 2N-1)
  if(floor(r).le.N) then
    do j = 1,N
      Trgt(floor(r),j) = .NOT.Trgt(floor(r),j)
    end do
  else
    r = r-N
    do j = 1,N
      Trgt(j,floor(r)) = .NOT.Trgt(j,floor(r))
    end do
  end if
end do

!This part checks if the target and the starting configurations are same or not.
do
  input = N
  call next_move(Brd,Trgt,N,input,solved)
  call next_move(Brd,Trgt,N,input,solved)
  if(solved) then
    r = 1+2.0D0*dble(N)*rand() - 1.0D-17
    if(floor(r).le.N) then
      do j = 1,N
        Trgt(floor(r),j) = .NOT.Trgt(floor(r),j)
      end do
    else
      r = r-N
      do j = 1,N
        Trgt(j,floor(r)) = .NOT.Trgt(j,floor(r))
      end do
    end if
  else
    exit
  end if
end do

write(*,*) 'Welcome to the Flipping Bits game!'
write(*,*) 'You have the current position'

moves = 0
call display(Brd,Trgt,N)
input = N
do
  write(*,*) 'Number of moves so far:', moves
  write(*,*) 'Select the column or row you wish to flip: '
  read(*,*,iostat=io) input
  if(io.eq.0 .and. input.gt.0 .and. input.le.(2*N)) then
    moves = moves+1
    write(*,*) 'Flipping ', input
    call next_move(Brd,Trgt,N,input,solved)
    call display(Brd,Trgt,N)
    if(solved) exit
  else
    write(*,*) 'Please enter a valid column or row number. To quit, press Ctrl+C!'
  end if
end do

write(*,*) 'Congratulations! You finished the game!'
write(*,ifmt,advance='no') moves
write(*,*) ' moves were taken by you!!'
deallocate(Brd,Trgt)
end program

subroutine display(Brd,Trgt,N)
implicit none
!arguments
integer :: N
logical :: Brd(N,N), Trgt(N,N)
!local
character(len=*), parameter :: cfmt = "(A3)", ifmt = "(I3)"
integer :: i, j
write(*,*) 'Current Configuration: '
do i = 0,N
  if(i.eq.0) then
    write(*,cfmt,advance='no') 'R/C'
    write(*,cfmt,advance='no') ' | '
  else
    write(*,ifmt,advance='no') i
  end if
end do
write(*,*)
do i = 0,N
  if(i.eq.0) then
    do j = 0,N+2
      write(*,cfmt,advance='no') '---'
    end do
  else
    write(*,ifmt,advance='no') i+N
    write(*,cfmt,advance='no') ' | '
    do j = 1,N
      if(Brd(i,j)) then
        write(*,ifmt,advance='no') 1
      else
        write(*,ifmt,advance='no') 0
      end if
    end do
  end if
  write(*,*)
end do

write(*,*)
write(*,*)

write(*,*) 'Target Configuration'
do i = 0,N
  if(i.eq.0) then
    write(*,cfmt,advance='no') 'R/C'
    write(*,cfmt,advance='no') ' | '
  else
    write(*,ifmt,advance='no') i
  end if
end do
write(*,*)
do i = 0,N
  if(i.eq.0) then
    do j = 0,N+2
      write(*,cfmt,advance='no') '---'
    end do
  else
    write(*,ifmt,advance='no') i+N
    write(*,cfmt,advance='no') ' | '
    do j = 1,N
      if(Trgt(i,j)) then
        write(*,ifmt,advance='no') 1
      else
        write(*,ifmt,advance='no') 0
      end if
    end do
  end if
  write(*,*)
end do
write(*,*)
write(*,*)
end subroutine

subroutine next_move(Brd,Trgt,N,input,solved)
implicit none
!arguments
integer :: N, input
logical :: Brd(N,N), Trgt(N,N), solved
!others
integer :: i,j

if(input.gt.N) then
  input = input-N
  do i = 1,N
    Brd(input,i) = .not.Brd(input,i)
  end do
else
  do i = 1,N
    Brd(i,input) = .not.Brd(i,input)
  end do
end if
solved = .TRUE.
do i = 1,N
  do j = 1,N
    if( (.not.Brd(i,j).and.Trgt(i,j)) .or. (Brd(i,j).and..not.Trgt(i,j)) ) then
      solved = .FALSE.
      exit
    end if
  end do
  if(.not.solved) exit
end do
end subroutine
