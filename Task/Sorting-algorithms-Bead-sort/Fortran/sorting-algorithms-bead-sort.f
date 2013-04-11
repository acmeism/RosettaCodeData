program BeadSortTest
  use iso_fortran_env
  ! for ERROR_UNIT; to make this a F95 code,
  ! remove prev. line and declare ERROR_UNIT as an
  ! integer parameter matching the unit associated with
  ! standard error

  integer, dimension(7) :: a = (/ 7, 3, 5, 1, 2, 1, 20 /)

  call beadsort(a)
  print *, a

contains

  subroutine beadsort(a)
    integer, dimension(:), intent(inout) :: a

    integer, dimension(maxval(a), maxval(a)) :: t
    integer, dimension(maxval(a)) :: s
    integer :: i, m

    m = maxval(a)

    if ( any(a < 0) ) then
       write(ERROR_UNIT,*) "can't sort"
       return
    end if

    t = 0
    forall(i=1:size(a)) t(i, 1:a(i)) = 1  ! set up abacus
    forall(i=1:m)             ! let beads "fall"; instead of
       s(i) = sum(t(:, i))    ! moving them one by one, we just
       t(:, i) = 0            ! count how many should be at bottom,
       t(1:s(i), i) = 1       ! and then "reset" and set only those
    end forall

    forall(i=1:size(a)) a(i) = sum(t(i,:))

  end subroutine beadsort

end program BeadSortTest
