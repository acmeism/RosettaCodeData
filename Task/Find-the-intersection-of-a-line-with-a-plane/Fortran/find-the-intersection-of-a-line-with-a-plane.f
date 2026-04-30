!
! Find the intersection of a line with a plane
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 26.04
!             GNU gfortran (Ubuntu 15.2.0-16ubuntu1) 15.2.0 on Kubuntu 26.04
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS V9.2-3
! U.B., April 2026
!
program LinePlaneIntersecion

integer, parameter :: tReal8 = 8

real (kind=tReal8), dimension(3) :: LineDirec, LinePoint
real (kind=tReal8), dimension(3) :: PlaneNormalVec, PlanePoint

! Case 1: Values from Task description
LineDirec = [0,-1,-1]
LinePoint = [0,0,10]
PlaneNormalVec = [0,0,1]
PlanePoint = [0,0,5]

call CalcIntersectionPoint()

! Line is on/in plane
LineDirec = [1,1,0]
LinePoint = [1,1,0]
PlaneNormalVec = [0,0,1]
PlanePoint = [5,1,0]

call CalcIntersectionPoint()

! Line is parallel to plane
LineDirec = [1,1,0]
LinePoint = [1,1,1]
PlaneNormalVec = [0,0,1]
PlanePoint = [5,1,0]

call CalcIntersectionPoint()

contains


! =================================================================================================================
! Calculate and print the coordinates of the intersection point of the line and the plane as given in main program.
! The method is described in a wikipedia article, see
!   https://en.wikipedia.org/wiki/Line%E2%80%93plane_intersection#Algebraic_form
! If line and plane are parallel, or if th line is contained in the plane, do not print the coordinates but
! print just that as a statement.
! =================================================================================================================
subroutine CalcIntersectionPoint()

real (kind=tReal8) :: d, prod12, prod2
real (kind=tReal8), dimension(3) :: result

prod1 = dot_product (PlanePoint - LinePoint, PlaneNormalVec)
prod2 = dot_product (LineDirec, PlaneNormalVec)


if (prod1 .eq. 0) then
  write (*, '("Line is contained in the Plane.")')
  return
endif
if (prod2 .eq. 0 ) then
  write (*, '("Line and Plane are parallel.")')
  return
endif

d = prod1 / prod2
result = LinePoint + d*LineDirec

write (*, '("The line intersects the plane at ")', advance='no')
write (*,'("(", 2(F5.2,x), F5.2, ")")', advance='no')   Result(1),Result(2),Result(3)
write (*, *)

end subroutine CalcIntersectionPoint

end program LinePlaneIntersecion
