subroutine distcheck(randgen, n, delta)

  interface
    function randgen
      integer :: randgen
    end function randgen
  end interface

  real, intent(in) :: delta
  integer, intent(in) :: n
  integer :: i, mval, lolim, hilim
  integer, allocatable :: buckets(:)
  integer, allocatable :: rnums(:)
  logical :: skewed = .false.

  allocate(rnums(n))

  do i = 1, n
    rnums(i) = randgen()
  end do

  mval = maxval(rnums)
  allocate(buckets(mval))
  buckets = 0

  do i = 1, n
    buckets(rnums(i)) = buckets(rnums(i)) + 1
  end do

  lolim = n/mval - n/mval*delta
  hilim = n/mval + n/mval*delta

  do i = 1, mval
    if(buckets(i) < lolim .or. buckets(i) > hilim) then
      write(*,"(a,i0,a,i0,a,i0)") "Distribution potentially skewed for bucket ", i, "   Expected: ", &
                                   n/mval, "   Actual: ", buckets(i)
      skewed = .true.
    end if
  end do

  if (.not. skewed) write(*,"(a)") "Distribution uniform"

  deallocate(rnums)
  deallocate(buckets)

end subroutine
