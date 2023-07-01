module Ray_Casting_Algo
  use Polygons
  implicit none

  real, parameter, private :: eps = 0.00001
  private :: ray_intersects_seg

contains

  function ray_intersects_seg(p0, a0, b0) result(intersect)
    type(point), intent(in) :: p0, a0, b0
    logical :: intersect

    type(point) :: a, b, p
    real :: m_red, m_blue

    p = p0
    ! let variable "a" be the point with smallest y coordinate
    if ( a0%y > b0%y ) then
       b = a0
       a = b0
    else
       a = a0
       b = b0
    end if

    if ( (p%y == a%y) .or. (p%y == b%y) ) p%y = p%y + eps

    intersect = .false.

    if ( (p%y > b%y) .or. (p%y < a%y) ) return
    if ( p%x > max(a%x, b%x) ) return

    if ( p%x < min(a%x, b%x) ) then
       intersect = .true.
    else
       if ( abs(a%x - b%x) > tiny(a%x) ) then
          m_red = (b%y - a%y) / (b%x - a%x)
       else
          m_red = huge(m_red)
       end if
       if ( abs(a%x - p%x) > tiny(a%x) ) then
          m_blue = (p%y - a%y) / (p%x - a%x)
       else
          m_blue = huge(m_blue)
       end if
       if ( m_blue >= m_red ) then
          intersect = .true.
       else
          intersect = .false.
       end if
    end if

  end function ray_intersects_seg

  function point_is_inside(p, pol) result(inside)
    logical :: inside
    type(point), intent(in) :: p
    type(polygon), intent(in) :: pol

    integer :: i, cnt, pa, pb

    cnt = 0
    do i = lbound(pol%vertices,1), ubound(pol%vertices,1), 2
       pa = pol%vertices(i)
       pb = pol%vertices(i+1)
       if ( ray_intersects_seg(p, pol%points(pa), pol%points(pb)) ) cnt = cnt + 1
    end do

    inside = .true.
    if ( mod(cnt, 2) == 0 ) then
       inside = .false.
    end if

  end function point_is_inside

end module Ray_Casting_Algo
