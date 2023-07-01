module Polygons
  use Points_Module
  implicit none

  type polygon
     type(point), dimension(:), allocatable :: points
     integer, dimension(:), allocatable :: vertices
  end type polygon

contains

  function create_polygon(pts, vt)
    type(polygon) :: create_polygon
    type(point), dimension(:), intent(in) :: pts
    integer, dimension(:), intent(in) :: vt

    integer :: np, nv

    np = size(pts,1)
    nv = size(vt,1)

    allocate(create_polygon%points(np), create_polygon%vertices(nv))
    create_polygon%points = pts
    create_polygon%vertices = vt

  end function create_polygon

  subroutine free_polygon(pol)
    type(polygon), intent(inout) :: pol

    deallocate(pol%points, pol%vertices)

  end subroutine free_polygon

end module Polygons
