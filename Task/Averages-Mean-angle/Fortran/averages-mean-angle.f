!-*- mode: compilation; default-directory: "/tmp/" -*-
!Compilation started at Mon Jun  3 18:07:59
!
!a=./f && make $a && OMP_NUM_THREADS=2 $a
!gfortran -std=f2008 -Wall -fopenmp -ffree-form -fall-intrinsics -fimplicit-none f.f08 -o f
!  -7.80250048E-06         350          10
!   90.0000000              90         180         270         360
!   19.9999962              10          20          30
!
!Compilation finished at Mon Jun  3 18:07:59

program average_angles
  !real(kind=8), parameter :: TAU = 6.283185307179586232 ! http://tauday.com/
  !integer, dimension(13), parameter :: test_data = (/2,350,10, 4,90,180,270,360, 3,10,20,30, 0/)
  !integer :: i, j, n
  !complex(kind=16) :: some
  !real(kind=8) :: angle
  real, parameter :: TAU = 6.283185307179586232 ! http://tauday.com/
  integer, dimension(13), parameter :: test_data = (/2,350,10, 4,90,180,270,360, 3,10,20,30, 0/)
  integer :: i, j, n
  complex :: some
  real :: angle
  i = 1
  n = int(test_data(i))
  do while (0 .lt. n)
    some = 0
    do j = 1, n
      angle = (TAU/360)*test_data(i+j)
      some = some + cmplx(cos(angle), sin(angle))
    end do
    some = some / n
    write(6,*)(360/TAU)*atan2(aimag(some), real(some)),test_data(i+1:i+n)
    i = i + n + 1
    n = int(test_data(i))
  end do
end program average_angles
