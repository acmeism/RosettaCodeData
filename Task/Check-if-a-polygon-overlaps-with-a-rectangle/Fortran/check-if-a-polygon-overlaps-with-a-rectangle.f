! Check if a polygon overlaps with a rectangle
!
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., March 2026
!
program Rectangle_overlap
implicit none

type :: Point
    real :: x, y
end type Point

Type :: Rectangle
  type(Point) :: BottomLeft
  real :: w, h
end type Rectangle

type(Point), dimension(:), allocatable :: Polygon, PolyRect1, PolyRect2
type(Rectangle) ::  Rectangle1, Rectangle2

! VSI Fortran V8.7 is still Fortran 95 standard only and cannot handle implicit allocation by assignment.
! These explicit allocate statements would not be necessary when using Fortran 2003, e.g. current
! gfortran 15.2.0 and ifx 2025.2.1
!
allocate (Polygon(5))
allocate (PolyRect1(4))       ! to convert BottomLeft, width,height to 4 Points
allocate (PolyRect2(4))

! The polygon that is used in all solutions
!          Bottom left       top left         top center       top right        bottom right
Polygon = [Point (0.0, 0.0), Point(0.0, 2.0), Point(1.0, 4.0), Point(2.0, 2.0), Point(2.0, 0.0) ]

! The 2 rectangles used in all solutions
Rectangle1 = Rectangle(Point (4.0, 0.0), 2.0, 2.0)
Rectangle2 = Rectangle(Point (1.0, 0.0), 8.0, 2.0)

! Convert the rectangle's representation (Bottom left X/Y, width, height) to
! coordinates of the 4 corners. Assume that the edges of the rectangle are
! parallel to the x-axis and the y-axis.
!
! Care to have the orientation of the points right: clock-wise around the rectangle,
! es the Polygon does.
!
PolyRect1(1)   = Rectangle1%BottomLeft                          ! Bottom left
PolyRect1(2)%x = Rectangle1%BottomLeft%x                        ! Top left
PolyRect1(2)%y = Rectangle1%BottomLeft%y+Rectangle1%h
PolyRect1(3)%x = Rectangle1%BottomLeft%x+Rectangle1%w           ! Top right
PolyRect1(3)%y = Rectangle1%BottomLeft%y+Rectangle1%h
PolyRect1(4)%x = Rectangle1%BottomLeft%x+Rectangle1%w           ! Bottom right
PolyRect1(4)%y = Rectangle1%BottomLeft%y

PolyRect2(1)   = Rectangle2%BottomLeft
PolyRect2(2)%x = Rectangle2%BottomLeft%x
PolyRect2(2)%y = Rectangle2%BottomLeft%y+Rectangle2%h
PolyRect2(3)%x = Rectangle2%BottomLeft%x+Rectangle2%w
PolyRect2(3)%y = Rectangle2%BottomLeft%y+Rectangle2%h
PolyRect2(4)%x = Rectangle2%BottomLeft%x+Rectangle2%w
PolyRect2(4)%y = Rectangle2%BottomLeft%y

! Print the input data
write (*, '("Polygon = ", 4 ("(",F3.1, ",",F3.1,"), "), "(",F3.1, ",",F3.1,")" )')   Polygon
!
write (*, '("Rectangle1 = ", 1 ("(",F3.1, ",",F3.1,")," ) , "(",F3.1, ",",F3.1,")  => ",&
&                            3 ("(",F3.1, ",",F3.1,")," ) , "(",F3.1, ",",F3.1,")" )')   Rectangle1, PolyRect1
write (*, '("Rectangle2 = ", 1 ("(",F3.1, ",",F3.1,")," ),  "(",F3.1, ",",F3.1,")  => ",&
&                            3 ("(",F3.1, ",",F3.1,"), "),  "(",F3.1, ",",F3.1,")" )')   Rectangle2, PolyRect2
write (*,*)
!
! ===================================================================================
! Attention: overlapCheck () does not check if the polygons represent a convex shape!
! ===================================================================================
!
! the overlapCheck subroutine prints the result.
call overlapCheck (PolyRect1, 'Rectangle1', size(PolyRect1), Polygon, 'Polygon', size(Polygon))
call overlapCheck (PolyRect2, 'Rectangle2', size(PolyRect2), Polygon, 'Polygon', size(Polygon))
!call overlapCheck (Polygon1, 'Polygon1', size(Polygon1), Polygon3, 'Polygon3', size(Polygon3))
!call overlapCheck (Polygon2, 'Polygon2', size(Polygon2), Polygon3, 'Polygon3', size(Polygon3))


contains

subroutine overlapCheck (PolA, nameA, sizPolA,  PolB, nameB, sizPolB)

implicit none

integer, intent(in) :: sizPolA, sizPolB
type(Point), intent(in)  :: polA(sizPolA), polB(sizPolB)
character(len=*) :: nameA, nameB

logical :: overlaps
integer :: ii

write (*,'(A, " and ", A)', advance='no') nameA, nameB
! ===================================================================================

overlaps = check_overlap(PolA, sizPolA,  PolB, sizPolB)

if (overlaps) then
  write (*,'(A)') "        Overlap"
else
  write (*,'(A)') " do not Overlap"
end if

end subroutine overlapCheck



logical function check_overlap(a, sizeA,  b, sizeB)

implicit none
integer, intent(in) :: sizeA, sizeB

type(Point), intent(in) :: a(sizeA), b(sizeB)
type(Point) :: axes(sizeA+sizeB)
integer :: i
real :: minA, maxA, minB, maxB

! 1. GENERATE SEARCH AXES
! According to SAT, if two convex shapes are separated,
! they must be separated by an axis perpendicular to one of their edges.

axes(1:sizeA) = get_normals(a, sizeA)
axes(sizeA+1:sizeA+SizeB ) = get_normals(b, sizeB)

! Assume they overlap until proven otherwise
check_overlap = .true.

! 2. TEST EACH AXIS
do i=1, sizeA+sizeB
  call project(a, sizeA, axes(i), minA, maxA)
  call project(b, sizeB, axes(i), minB, maxB)

  ! 3. CHECK FOR GAP
  ! If the intervals (shadows) do not overlap, we found a "separating axis".
  ! If even one such axis exists, the triangles cannot be touching.
  if (maxA < minB .or. maxB < minA) then
     check_overlap = .false.    ! No overlap
      return                    ! Exit early: No need to check other axes
  end if
end do
end function check_overlap

function get_normals(p, sizeP) result(n)

implicit none
integer, intent(in) :: sizeP
type(Point), intent(in) :: p(sizeP)
type(Point) :: n(sizeP)
integer :: i, j
real :: dx, dy
do i = 1, sizeP
    j = mod(i, sizeP) + 1

    ! Vector representing the edge between two vertices
    dx = p(j)%x - p(i)%x
    dy = p(j)%y - p(i)%y

    ! The normal vector (perpendicular) is (-dy, dx)
    n(i) = Point(-dy, dx)
end do
end function get_normals

subroutine project(p, sizeP, axis, minP, maxP)

implicit none
integer, intent(in) :: sizeP
type(Point), intent(in) :: p(sizeP), axis
real, intent(out) :: minP, maxP
real :: dot_val
integer :: i

! Project the first vertex using the Dot Product: (A.x * B.x) + (A.y * B.y)
minP = (p(1)%x * axis%x) + (p(1)%y * axis%y)
maxP = minP

! Project remaining vertices and find the min/max bounds of the shadow
do i = 2, 3
  dot_val = (p(i)%x * axis%x) + (p(i)%y * axis%y)
  if (dot_val < minP) minP = dot_val
  if (dot_val > maxP) maxP = dot_val
end do
end subroutine project

end program Rectangle_overlap
