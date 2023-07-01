!Implemented by Anant Dixit (October, 2014)
program animated_pendulum
implicit none
double precision, parameter :: pi = 4.0D0*atan(1.0D0), l = 1.0D-1, dt = 1.0D-2, g = 9.8D0
integer :: io
double precision :: s_ang, c_ang, p_ang, n_ang

write(*,*) 'Enter starting angle (in degrees):'
do
  read(*,*,iostat=io) s_ang
  if(io.ne.0 .or. s_ang.lt.-90.0D0 .or. s_ang.gt.90.0D0) then
    write(*,*) 'Please enter an angle between 90 and -90 degrees:'
  else
    exit
  end if
end do
call execute_command_line('cls')

c_ang = s_ang*pi/180.0D0
p_ang = c_ang

call display(c_ang)
do
  call next_time_step(c_ang,p_ang,g,l,dt,n_ang)
  if(abs(c_ang-p_ang).ge.0.05D0) then
    call execute_command_line('cls')
    call display(c_ang)
  end if
end do
end program

subroutine next_time_step(c_ang,p_ang,g,l,dt,n_ang)
double precision :: c_ang, p_ang, g, l, dt, n_ang
n_ang = (-g*sin(c_ang)/l)*2.0D0*dt**2 + 2.0D0*c_ang - p_ang
p_ang = c_ang
c_ang = n_ang
end subroutine

subroutine display(c_ang)
double precision :: c_ang
character (len=*), parameter :: cfmt = '(A1)'
double precision :: rx, ry
integer :: x, y, i, j
rx = 45.0D0*sin(c_ang)
ry = 22.5D0*cos(c_ang)
x = int(rx)+51
y = int(ry)+2
do i = 1,32
  do j = 1,100
    if(i.eq.y .and. j.eq.x) then
      write(*,cfmt,advance='no') 'O'
    else if(i.eq.y .and. (j.eq.(x-1).or.j.eq.(x+1))) then
      write(*,cfmt,advance='no') 'G'
    else if(j.eq.x .and. (i.eq.(y-1).or.i.eq.(y+1))) then
      write(*,cfmt,advance='no') 'G'
    else if(i.eq.y .and. (j.eq.(x-2).or.j.eq.(x+2))) then
      write(*,cfmt,advance='no') '#'
    else if(j.eq.x .and. (i.eq.(y-2).or.i.eq.(y+2))) then
      write(*,cfmt,advance='no') 'G'
    else if((i.eq.(y+1).and.j.eq.(x+1)) .or. (i.eq.(y-1).and.j.eq.(x-1))) then
      write(*,cfmt,advance='no') '#'
    else if((i.eq.(y+1).and.j.eq.(x-1)) .or. (i.eq.(y-1).and.j.eq.(x+1))) then
      write(*,cfmt,advance='no') '#'
    else if(j.eq.50) then
      write(*,cfmt,advance='no') '|'
    else if(i.eq.2) then
      write(*,cfmt,advance='no') '-'
    else
      write(*,cfmt,advance='no') ' '
    end if
  end do
  write(*,*)
end do
end subroutine
