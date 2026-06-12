! Check if two polygons overlap
!
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., March 2026
!
program Polygon_overlap
implicit none

type :: Point
    real :: x, y
end type Point

type(Point), dimension(:), allocatable :: Polygon1, Polygon2, Polygon3

! VSI Fortran V8.7 is still Fortran 95 standard only and cannot handle implicit allocation by assignment.
! These explicit allocate statements would not be necessary when using Fortran 2003, e.g. current
! gfortran 15.2.0 and ifx 2025.2.1
!
allocate (Polygon1(5))
allocate (polygon2(5))
allocate (polygon3(5))

Polygon1 = [Point (0.0, 0.0), Point(0.0, 2.0), Point(1.0, 4.0), Point(2.0, 2.0), Point(2.0, 0.0) ]
Polygon2 = [Point (4.0, 0.0), Point(4.0, 2.0), Point(5.0, 4.0), Point(6.0, 2.0), Point(6.0, 0.0) ]
Polygon3 = [Point (1.0, 0.0), Point(1.0, 2.0), Point(5.0, 4.0), Point(9.0, 2.0), Point(9.0, 0.0) ]

! Print the input data
write (*, '("Polygon1 = ", 4 ("(",F3.1, ",",F3.1,"), "), "(",F3.1, ",",F3.1,")" )')   Polygon1
write (*, '("Polygon2 = ", 4 ("(",F3.1, ",",F3.1,"), "), "(",F3.1, ",",F3.1,")" )')   Polygon2
write (*, '("Polygon3 = ", 4 ("(",F3.1, ",",F3.1,"), "), "(",F3.1, ",",F3.1,")" )')   Polygon3
write (*,*)

! ===================================================================================
! Attention: overlapCheck () does not check if the polygons represent a convex shape!
! ===================================================================================
!
! the overlapCheck subroutine prints the result.
call overlapCheck (Polygon1, 'Polygon1', size(Polygon1), Polygon2, 'Polygon2', size(Polygon2))
call overlapCheck (Polygon1, 'Polygon1', size(Polygon1), Polygon3, 'Polygon3', size(Polygon3))
call overlapCheck (Polygon2, 'Polygon2', size(Polygon2), Polygon3, 'Polygon3', size(Polygon3))


contains

subroutine overlapCheck (PolA, nameA, sizPolA,  PolB, nameB, sizPolB)

implicit none

integer, intent(in) :: sizPolA, sizPolB
type(Point), intent(in)  :: polA(sizPolA), polB(sizPolB)
character(len=*) :: nameA, nameB

logical :: overlaps
integer :: ii

write (*,'(A, " and ", A)', advance='no') nameA, nameB

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

end program Polygon_overlap
