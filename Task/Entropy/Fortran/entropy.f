!-*- mode: compilation; default-directory: "/tmp/" -*-
!Compilation started at Tue May 21 21:43:12
!
!a=./f && make $a && OMP_NUM_THREADS=2 $a 1223334444
!gfortran -std=f2008 -Wall -ffree-form -fall-intrinsics f.f08 -o f
! Shannon entropy of 1223334444 is    1.84643936
!
!Compilation finished at Tue May 21 21:43:12

program shannonEntropy
  implicit none
  integer :: num, L, status
  character(len=2048) :: s
  num = 1
  call get_command_argument(num, s, L, status)
  if ((0 /= status) .or. (L .eq. 0)) then
    write(0,*)'Expected a command line argument with some length.'
  else
    write(6,*)'Shannon entropy of '//(s(1:L))//' is ', se(s(1:L))
  endif

contains
  !     algebra
  !
  ! 2**x = y
  ! x*log(2) = log(y)
  ! x = log(y)/log(2)

  !   NB. The j solution
  !   entropy=:  +/@:-@(* 2&^.)@(#/.~ % #)
  !   entropy '1223334444'
  !1.84644

  real function se(s)
    implicit none
    character(len=*), intent(in) :: s
    integer, dimension(256) :: tallies
    real, dimension(256) :: norm
    tallies = 0
    call TallyKey(s, tallies)
    ! J's #/. works with the set of items in the input.
    ! TallyKey is sufficiently close that, with the merge, gets the correct result.
    norm = tallies / real(len(s))
    se = sum(-(norm*log(merge(1.0, norm, norm .eq. 0))/log(2.0)))
  end function se

  subroutine TallyKey(s, counts)
    character(len=*), intent(in) :: s
    integer, dimension(256), intent(out) :: counts
    integer :: i, j
    counts = 0
    do i=1,len(s)
      j = iachar(s(i:i))
      counts(j) = counts(j) + 1
    end do
  end subroutine TallyKey

end program shannonEntropy
