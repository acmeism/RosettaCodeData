!-*- mode: compilation; default-directory: "/tmp/" -*-
!Compilation started at Mon Jun  3 23:08:36
!
!a=./f && make $a && OMP_NUM_THREADS=2 $a
!gfortran -std=f2008 -Wall -fopenmp -ffree-form -fall-intrinsics -fimplicit-none f.f08 -o f
!
!$ ./f
! Choose fairly a tail
!       1: fee fie
!       2: huff and puff
!       3: mirror mirror
!       4: tick tock
!bad input
! Choose fairly a tail
!       1: fee fie
!       2: huff and puff
!       3: mirror mirror
!       4: tick tock
!^D
!
!STOP Unexpected end of file
!$ ./f
! Choose fairly a tail
!       1: fee fie
!       2: huff and puff
!       3: mirror mirror
!       4: tick tock
!88
! Choose fairly a tail
!       1: fee fie
!       2: huff and puff
!       3: mirror mirror
!       4: tick tock
!-88
! Choose fairly a tail
!       1: fee fie
!       2: huff and puff
!       3: mirror mirror
!       4: tick tock
!3.2
! Choose fairly a tail
!       1: fee fie
!       2: huff and puff
!       3: mirror mirror
!       4: tick tock
!2
! huff and puff
!$

module menu
contains
  function selector(title, options, n) result(choice)
    integer, optional, intent(in) :: n
    character(len=*), intent(in) :: title
    character(len=*),dimension(:),intent(in) :: options
    !character(len=:), allocatable :: choice ! requires deallocation
    !allocate(character(len=8)::choice)
    character(len=128) :: choice
    integer :: i, L, ios
    L = merge(n, size(options), present(n))
    if (L .lt. 1) stop 'Silly input'
    if (len(choice) .lt. len(options(1))) stop 'menu choices are excessively long'
    i = 0
    do while ((ios.ne.0) .or. ((i.lt.1) .or. (L.lt.i)))
       write(6,*) title
       write(6,"(i8,': ',a)")(i,options(i),i=1,L)
       read(5,*,iostat=ios,end=666) i
    end do
    choice = options(i)
    return
666 continue
    stop 'Unexpected end of file'
  end function selector
end module menu

program menu_demo
  use menu
  character(len=14), dimension(4) :: items = (/'fee fie       ', 'huff and puff ', 'mirror mirror ','tick tock     '/)
  print*,selector('Choose fairly a tail', items)
end program menu_demo
