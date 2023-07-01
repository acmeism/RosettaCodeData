module SutherlandHodgmanUtil
  ! functions and type needed for Sutherland-Hodgman algorithm

  ! -------------------------------------------------------- !
  type polygon
    !type for polygons
    ! when you define a polygon, the first and the last vertices have to be the same
    integer :: n
    double precision, dimension(:,:), allocatable :: vertex
  end type polygon

  contains

  ! -------------------------------------------------------- !
  subroutine sutherlandHodgman( ref, clip, outputPolygon )
    ! Sutherland Hodgman algorithm for 2d polygons

    ! -- parameters of the subroutine --
    type(polygon) :: ref, clip, outputPolygon

    ! -- variables used is the subroutine
    type(polygon) :: workPolygon               ! polygon clipped step by step
    double precision, dimension(2) :: y1,y2    ! vertices of edge to clip workPolygon
    integer :: i

    ! allocate workPolygon with the maximal possible size
    !   the sum of the size of polygon ref and clip
    allocate(workPolygon%vertex( ref%n+clip%n , 2 ))

    !  initialise the work polygon with clip
    workPolygon%n = clip%n
    workPolygon%vertex(1:workPolygon%n,:) = clip%vertex(1:workPolygon%n,:)

    do i=1,ref%n-1 ! for each edge i of the polygon ref
      y1(:) = ref%vertex(i,:)   !  vertex 1 of edge i
      y2(:) = ref%vertex(i+1,:) !  vertex 2 of edge i

      ! clip the work polygon by edge i
      call edgeClipping( workPolygon, y1, y2, outputPolygon)
      ! workPolygon <= outputPolygon
      workPolygon%n = outputPolygon%n
      workPolygon%vertex(1:workPolygon%n,:) = outputPolygon%vertex(1:workPolygon%n,:)

    end do
    deallocate(workPolygon%vertex)
  end subroutine sutherlandHodgman

  ! -------------------------------------------------------- !
  subroutine edgeClipping( poly, y1, y2, outputPoly )
    ! make the clipping  of the polygon by the line (x1x2)

    type(polygon) :: poly, outputPoly
    double precision, dimension(2) :: y1, y2, x1, x2, intersecPoint
    integer ::  i, c

    c = 0 ! counter for the output polygon

    do i=1,poly%n-1 ! for each edge i of poly
      x1(:) = poly%vertex(i,:)   ! vertex 1 of edge i
      x2(:) = poly%vertex(i+1,:) ! vertex 2 of edge i

      if ( inside(x1, y1, y2) ) then ! if vertex 1 in inside clipping region
        if ( inside(x2, y1, y2) ) then ! if vertex 2 in inside clipping region
          ! add the vertex 2 to the output polygon
          c = c+1
          outputPoly%vertex(c,:) = x2(:)

        else ! vertex i+1 is outside
          intersecPoint = intersection(x1, x2, y1,y2)
          c = c+1
          outputPoly%vertex(c,:) = intersecPoint(:)
        end if
      else ! vertex i is outside
        if ( inside(x2, y1, y2) ) then
          intersecPoint = intersection(x1, x2, y1,y2)
          c = c+1
          outputPoly%vertex(c,:) = intersecPoint(:)

          c = c+1
          outputPoly%vertex(c,:) = x2(:)
        end if
      end if
    end do

    if (c .gt. 0) then
      ! if the last vertice is not equal to the first one
      if ( (outputPoly%vertex(1,1) .ne. outputPoly%vertex(c,1)) .or. &
           (outputPoly%vertex(1,2) .ne. outputPoly%vertex(c,2)))  then
        c=c+1
        outputPoly%vertex(c,:) = outputPoly%vertex(1,:)
      end if
    end if
    ! set the size of the outputPolygon
    outputPoly%n = c
  end subroutine edgeClipping

  ! -------------------------------------------------------- !
  function intersection( x1, x2, y1, y2)
    ! computes the intersection between segment [x1x2]
    ! and line the line (y1y2)

    ! -- parameters of the function --
    double precision, dimension(2) :: x1, x2, &  ! points of the segment
                                      y1, y2     ! points of the line

    double precision, dimension(2) :: intersection, vx, vy, x1y1
    double precision :: a

    vx(:) = x2(:) - x1(:)
    vy(:) = y2(:) - y1(:)

    ! if the vectors are colinear
    if ( crossProduct(vx,vy) .eq. 0.d0) then
      x1y1(:) = y1(:) - x1(:)
      ! if the the segment [x1x2] is included in the line (y1y2)
      if ( crossProduct(x1y1,vx) .eq. 0.d0) then
        ! the intersection is the last point of the segment
        intersection(:) = x2(:)
      end if
    else ! the vectors are not colinear
      ! we want to find the inersection between [x1x2]
      ! and (y1,y2).
      ! mathematically, we want to find a in [0;1] such
      ! that :
      !     x1 + a vx = y1 + b vy
      ! <=> a vx = x1y1 + b vy
      ! <=> a vx^vy = x1y1^vy      , ^ is cross product
      ! <=> a = x1y1^vy / vx^vy

      x1y1(:) = y1(:) - x1(:)
      ! we compute a
      a = crossProduct(x1y1,vy)/crossProduct(vx,vy)
      ! if a is not in [0;1]
      if ( (a .gt. 1.d0) .or. (a .lt. 0)) then
        ! no intersection
      else
        intersection(:) = x1(:) + a*vx(:)
      end if
    end if

  end function intersection


  ! -------------------------------------------------------- !
  function inside( p, y1, y2)
    ! function that tells is the point p is at left of the line (y1y2)

    double precision, dimension(2) :: p, y1, y2, v1, v2
    logical :: inside
    v1(:) = y2(:) -  y1(:)
    v2(:) = p(:)  -  y1(:)
    if ( crossProduct(v1,v2) .ge. 0.d0) then
      inside = .true.
    else
      inside = .false.
    end if

   contains
  end function inside

  ! -------------------------------------------------------- !
  function dotProduct( v1, v2)
    ! compute the dot product of vectors v1 and v2
    double precision, dimension(2) :: v1
    double precision, dimension(2) :: v2
    double precision :: dotProduct
    dotProduct = v1(1)*v2(1) + v1(2)*v2(2)
  end function dotProduct

  ! -------------------------------------------------------- !
  function crossProduct( v1, v2)
    ! compute the crossproduct of vectors v1 and v2
    double precision, dimension(2) :: v1
    double precision, dimension(2) :: v2
    double precision :: crossProduct
    crossProduct = v1(1)*v2(2) - v1(2)*v2(1)
  end function crossProduct

end module SutherlandHodgmanUtil

program main

  ! load the module for S-H algorithm
  use SutherlandHodgmanUtil, only : polygon, &
                                    sutherlandHodgman, &
                                    edgeClipping

  type(polygon) :: p1, p2, res
  integer :: c, n
  double precision, dimension(2) :: y1, y2

  ! when you define a polygon, the first and the last vertices have to be the same

  ! first polygon
  p1%n = 10
  allocate(p1%vertex(p1%n,2))
  p1%vertex(1,1)=50.d0
  p1%vertex(1,2)=150.d0

  p1%vertex(2,1)=200.d0
  p1%vertex(2,2)=50.d0

  p1%vertex(3,1)= 350.d0
  p1%vertex(3,2)= 150.d0

  p1%vertex(4,1)= 350.d0
  p1%vertex(4,2)= 300.d0

  p1%vertex(5,1)= 250.d0
  p1%vertex(5,2)= 300.d0

  p1%vertex(6,1)= 200.d0
  p1%vertex(6,2)= 250.d0

  p1%vertex(7,1)= 150.d0
  p1%vertex(7,2)= 350.d0

  p1%vertex(8,1)= 100.d0
  p1%vertex(8,2)= 250.d0

  p1%vertex(9,1)= 100.d0
  p1%vertex(9,2)= 200.d0

  p1%vertex(10,1)=  50.d0
  p1%vertex(10,2)= 150.d0

  y1 = (/ 100.d0, 300.d0 /)
  y2 = (/ 300.d0, 300.d0 /)

  ! second polygon
  p2%n = 5
  allocate(p2%vertex(p2%n,2))

  p2%vertex(1,1)= 100.d0
  p2%vertex(1,2)= 100.d0

  p2%vertex(2,1)= 300.d0
  p2%vertex(2,2)= 100.d0

  p2%vertex(3,1)= 300.d0
  p2%vertex(3,2)= 300.d0

  p2%vertex(4,1)= 100.d0
  p2%vertex(4,2)= 300.d0

  p2%vertex(5,1)= 100.d0
  p2%vertex(5,2)= 100.d0

  allocate(res%vertex(p1%n+p2%n,2))
  call sutherlandHodgman( p2, p1, res)
  write(*,*) "Suterland-Hodgman"
  do c=1, res%n
    write(*,*) res%vertex(c,1), res%vertex(c,2)
  end do
  deallocate(res%vertex)

end program main
