! program run with invalid name path/f
!
!-*- mode: compilation; default-directory: "/tmp/" -*-
!Compilation started at Sun Jun  2 00:18:31
!
!a=./f && make $a && OMP_NUM_THREADS=2 $a < unixdict.txt
!gfortran -std=f2008 -Wall -fopenmp -ffree-form -fall-intrinsics -fimplicit-none f.f08 -o f
!
!Compilation finished at Sun Jun  2 00:18:31



! program run with valid name path/rcname
!
!-*- mode: compilation; default-directory: "/tmp/" -*-
!Compilation started at Sun Jun  2 00:19:01
!
!gfortran -std=f2008 -Wall -fopenmp -ffree-form -fall-intrinsics -fimplicit-none f.f08 -o rcname && ./rcname
! ./rcname approved.
! program continues...
!
!Compilation finished at Sun Jun  2 00:19:02


module sundry

contains

  subroutine verify_name(required)
    ! name verification reduces the ways an attacker can rename rm as cp.
    character(len=*), intent(in) :: required
    character(len=1024) :: name
    integer :: length, status
    ! I believe get_command_argument is part of the 2003 FORTRAN standard intrinsics.
    call get_command_argument(0, name, length, status)
    if (0 /= status) stop
    if ((len_trim(name)+1) .ne. (index(name, required, back=.true.) + len(required))) stop
    write(6,*) trim(name)//' approved.'
  end subroutine verify_name

end module sundry

program name
  use sundry
  call verify_name('rcname')
  write(6,*)'program continues...'
end program name
