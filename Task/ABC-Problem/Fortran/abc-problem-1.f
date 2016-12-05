!-*- mode: compilation; default-directory: "/tmp/" -*-
!Compilation started at Thu Jun  5 01:52:03
!
!make f && for a in '' a bark book treat common squad confuse ; do echo $a | ./f ; done
!gfortran -std=f2008 -Wall -fopenmp -ffree-form -fall-intrinsics -fimplicit-none -g f.f08 -o f
! T
! T  A                    NA
! T  BARK                 BO NA RE XK
! F  BOOK                 OB BO -- --
! T  TREAT                GT RE ER NA TG
! F  COMMON               PC OB ZM -- -- --
! T  SQUAD                FS DQ HU NA QD
! T  CONFUSE              CP BO NA FS HU FS RE
!
!Compilation finished at Thu Jun  5 01:52:03

program abc
  implicit none
  integer, parameter :: nblocks = 20
  character(len=nblocks) :: goal
  integer, dimension(nblocks) :: solution
  character(len=2), dimension(0:nblocks) :: blocks_copy, blocks = &
       &(/'--','BO','XK','DQ','CP','NA','GT','RE','TG','QD','FS','JW','HU','VI','AN','OB','ER','FS','LY','PC','ZM'/)
  logical :: valid
  integer :: i, iostat
  read(5,*,iostat=iostat) goal
  if (iostat .ne. 0) goal = ''
  call ucase(goal)
  solution = 0
  blocks_copy = blocks
  valid = assign_block(goal(1:len_trim(goal)), blocks, solution, 1)
  write(6,*) valid, ' '//goal, (' '//blocks_copy(solution(i)), i=1,len_trim(goal))

contains

  recursive function assign_block(goal, blocks, solution, n) result(valid)
    implicit none
    logical :: valid
    character(len=*), intent(in) :: goal
    character(len=2), dimension(0:), intent(inout) :: blocks
    integer, dimension(:), intent(out) :: solution
    integer, intent(in) :: n
    integer :: i
    character(len=2) :: backing_store
    valid = .true.
    if (len(goal)+1 .eq. n) return
    do i=1, size(blocks)
       if (index(blocks(i),goal(n:n)) .ne. 0) then
          backing_store = blocks(i)
          blocks(i) = ''
          solution(n) = i
          if (assign_block(goal, blocks, solution, n+1)) return
          blocks(i) = backing_store
       end if
    end do
    valid = .false.
    return
  end function assign_block

  subroutine ucase(a)
    implicit none
    character(len=*), intent(inout) :: a
    integer :: i, j
    do i = 1, len_trim(a)
       j = index('abcdefghijklmnopqrstuvwxyz',a(i:i))
       if (j .ne. 0) a(i:i) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'(j:j)
    end do
  end subroutine ucase

end program abc
