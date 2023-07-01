module Polynom
  implicit none

contains

  subroutine poly_long_div(n, d, q, r)
    real, dimension(:), intent(in) :: n, d
    real, dimension(:), intent(out), allocatable :: q
    real, dimension(:), intent(out), allocatable, optional :: r

    real, dimension(:), allocatable :: nt, dt, rt
    integer :: gn, gt, gd

    if ( (size(n) >= size(d)) .and. (size(d) > 0) .and. (size(n) > 0) ) then
       allocate(nt(size(n)), dt(size(n)), rt(size(n)))

       nt = n
       dt = 0
       dt(1:size(d)) = d
       rt = 0
       gn = size(n)-1
       gd = size(d)-1
       gt = 0

       do while ( d(gd+1) == 0 )
          gd = gd - 1
       end do

       do while( gn >= gd )
          dt = eoshift(dt, -(gn-gd))
          rt(gn-gd+1) = nt(gn+1) / dt(gn+1)
          nt = nt - dt * rt(gn-gd+1)
          gt = max(gt, gn-gd)
          do
             gn = gn - 1
             if ( nt(gn+1) /= 0 ) exit
          end do
          dt = 0
          dt(1:size(d)) = d
       end do

       allocate(q(gt+1))
       q = rt(1:gt+1)
       if ( present(r) ) then
          if ( (gn+1) > 0 ) then
             allocate(r(gn+1))
             r = nt(1:gn+1)
          else
             allocate(r(1))
             r = 0.0
          end if
       end if
       deallocate(nt, dt, rt)
    else
       allocate(q(1))
       q = 0
       if ( present(r) ) then
          allocate(r(size(n)))
          r = n
       end if
    end if

  end subroutine poly_long_div

  subroutine poly_print(p)
    real, dimension(:), intent(in) :: p

    integer :: i

    do i = size(p), 1, -1
       if ( i > 1 ) then
          write(*, '(F0.2,"x^",I0," + ")', advance="no") p(i), i-1
       else
          write(*, '(F0.2)') p(i)
       end if
    end do

  end subroutine poly_print

end module Polynom
