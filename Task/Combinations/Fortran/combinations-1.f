program Combinations
  use iso_fortran_env
  implicit none

  type comb_result
     integer, dimension(:), allocatable :: combs
  end type comb_result

  type(comb_result), dimension(:), pointer :: r
  integer :: i, j

  call comb(5, 3, r)
  do i = 0, choose(5, 3) - 1
     do j = 2, 0, -1
        write(*, "(I4, ' ')", advance="no") r(i)%combs(j)
     end do
     deallocate(r(i)%combs)
     write(*,*) ""
  end do
  deallocate(r)

contains

  function choose(n, k, err)
    integer :: choose
    integer, intent(in) :: n, k
    integer, optional, intent(out) :: err

    integer :: imax, i, imin, ie

    ie = 0
    if ( (n < 0 ) .or. (k < 0 ) ) then
       write(ERROR_UNIT, *) "negative in choose"
       choose = 0
       ie = 1
    else
       if ( n < k ) then
          choose = 0
       else if ( n == k ) then
          choose = 1
       else
          imax = max(k, n-k)
          imin = min(k, n-k)
          choose = 1
          do i = imax+1, n
             choose = choose * i
          end do
          do i = 2, imin
             choose = choose / i
          end do
       end if
    end if
    if ( present(err) ) err = ie
  end function choose

  subroutine comb(n, k, co)
    integer, intent(in) :: n, k
    type(comb_result), dimension(:), pointer, intent(out) :: co

    integer :: i, j, s, ix, kx, hm, t
    integer :: err

    hm = choose(n, k, err)
    if ( err /= 0 ) then
       nullify(co)
       return
    end if

    allocate(co(0:hm-1))
    do i = 0, hm-1
       allocate(co(i)%combs(0:k-1))
    end do
    do i = 0, hm-1
       ix = i; kx = k
       do s = 0, n-1
          if ( kx == 0 ) exit
          t = choose(n-(s+1), kx-1)
          if ( ix < t ) then
             co(i)%combs(kx-1) = s
             kx = kx - 1
          else
             ix = ix - t
          end if
       end do
    end do

  end subroutine comb

end program Combinations
