! Determine if two triangles overlap
!
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU gfortran (Ubuntu 15.2.0-4ubuntu4)  15.2.0 on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., March 2026
!

program triangle_overlap
implicit none

type :: Point
    real :: x, y
end type Point


! The 6 triangle pairs of the task description:
call overlapCheck ([Point (0.0,0.0),Point(5.0,0.0),  Point(0.0,5.0)], [Point(  0.0,0.0), Point( 5.0, 0.0), Point( 0.0,6.0)])
call overlapCheck ([Point (0.0,0.0),Point(0.0,5.0),  Point(5.0,0.0)], [Point(  0.0,0.0), Point( 0.0, 5.0), Point( 5.0,0.0)])
call overlapCheck ([Point (0.0,0.0),Point(5.0,0.0),  Point(0.0,5.0)], [Point(-10.0,0.0), Point(-5.0, 5.0), Point(-1.0,6.0)])
call overlapCheck ([Point (0.0,0.0),Point(5.0,0.0),  Point(2.5,5.0)], [Point(  0.0,4.0), Point( 2.5,-1.0), Point( 5.0,4.0)])
call overlapCheck ([Point (0.0,0.0),Point(1.0,1.0),  Point(0.0,2.0)], [Point(  2.0,1.0), Point( 3.0, 0.0), Point( 3.0,2.0)])
call overlapCheck ([Point (0.0,0.0),Point(1.0,1.0),  Point(0.0,2.0)], [Point(  2.0,1.0), Point( 3.0,-2.0), Point( 3.0,4.0)])

! Optional:
call overlapCheck ([Point (0.0,0.0),Point(1.0,0.0),  Point(0.0,1.0)], [Point(  1.0,0.0), Point( 2.0,0.0), Point( 1.0,1.0)])


contains

subroutine overlapCheck (triA, triB)

implicit none

type(Point), intent(in)  :: triA(3), triB(3)
logical :: overlaps

write (*,'("Triangles ", 3("(",F5.1, ",",F5.1,")"),/, "and", 7x, 3("(",F5.1, ",",F5.1,")") )' , advance='no')   triA, triB

overlaps = check_overlap(triA, triB)

if (overlaps) then
  write (*,'(A,/)') "     Overlap"
else
  write (*,'(A,/)') "     Do not Overlap"
end if

end subroutine overlapCheck



logical function check_overlap(a, b)

implicit none

type(Point), intent(in) :: a(3), b(3)
type(Point) :: axes(6)
integer :: i
real :: minA, maxA, minB, maxB

! 1. GENERATE SEARCH AXES
! According to SAT, if two convex shapes are separated,
! they must be separated by an axis perpendicular to one of their edges.

axes(1:3) = get_normals(a)
axes(4:6) = get_normals(b)

! Assume they overlap until proven otherwise
check_overlap = .true.

! 2. TEST EACH AXIS
do i = 1, 6
  call project(a, axes(i), minA, maxA)
  call project(b, axes(i), minB, maxB)

  ! 3. CHECK FOR GAP
  ! If the intervals (shadows) do not overlap, we found a "separating axis".
  ! If even one such axis exists, the triangles cannot be touching.
  if (maxA < minB .or. maxB < minA) then
     check_overlap = .false.    ! No overlap
      return                    ! Exit early: No need to check other axes
  end if
end do
end function check_overlap

function get_normals(p) result(n)

implicit none

type(Point), intent(in) :: p(3)
type(Point) :: n(3)
integer :: i, j
real :: dx, dy
do i = 1, 3
    j = mod(i, 3) + 1

    ! Vector representing the edge between two vertices
    dx = p(j)%x - p(i)%x
    dy = p(j)%y - p(i)%y

    ! The normal vector (perpendicular) is (-dy, dx)
    n(i) = Point(-dy, dx)
end do
end function get_normals

subroutine project(p, axis, minP, maxP)

implicit none

type(Point), intent(in) :: p(3), axis
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

end program triangle_overlap
