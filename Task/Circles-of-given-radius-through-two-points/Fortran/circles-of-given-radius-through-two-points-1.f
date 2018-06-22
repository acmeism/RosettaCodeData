! Implemented by Anant Dixit (Nov. 2014)
! Transpose elements in find_center to obtain correct results. R.N. McLean (Dec 2017)
program circles
implicit none
double precision :: P1(2), P2(2), R

P1 = (/0.1234d0, 0.9876d0/)
P2 = (/0.8765d0,0.2345d0/)
R = 2.0d0
call print_centers(P1,P2,R)

P1 = (/0.0d0, 2.0d0/)
P2 = (/0.0d0,0.0d0/)
R = 1.0d0
call print_centers(P1,P2,R)

P1 = (/0.1234d0, 0.9876d0/)
P2 = (/0.1234d0, 0.9876d0/)
R = 2.0d0
call print_centers(P1,P2,R)

P1 = (/0.1234d0, 0.9876d0/)
P2 = (/0.8765d0, 0.2345d0/)
R = 0.5d0
call print_centers(P1,P2,R)

P1 = (/0.1234d0, 0.9876d0/)
P2 = (/0.1234d0, 0.9876d0/)
R = 0.0d0
call print_centers(P1,P2,R)
end program circles

subroutine print_centers(P1,P2,R)
implicit none
double precision :: P1(2), P2(2), R, Center(2,2)
integer :: Res
call test_inputs(P1,P2,R,Res)
write(*,*)
write(*,'(A10,F7.4,A1,F7.4)') 'Point1  : ', P1(1), ' ', P1(2)
write(*,'(A10,F7.4,A1,F7.4)') 'Point2  : ', P2(1), ' ', P2(2)
write(*,'(A10,F7.4)') 'Radius  : ', R
if(Res.eq.1) then
  write(*,*) 'Same point because P1=P2 and r=0.'
elseif(Res.eq.2) then
  write(*,*) 'No circles can be drawn because r=0.'
elseif(Res.eq.3) then
  write(*,*) 'Infinite circles because P1=P2 for non-zero radius.'
elseif(Res.eq.4) then
  write(*,*) 'No circles with given r can be drawn because points are far apart.'
elseif(Res.eq.0) then
  call find_center(P1,P2,R,Center)
  if(Center(1,1).eq.Center(2,1) .and. Center(1,2).eq.Center(2,2)) then
    write(*,*) 'Points lie on the diameter. A single circle can be drawn.'
    write(*,'(A10,F7.4,A1,F7.4)') 'Center  : ', Center(1,1), ' ', Center(1,2)
  else
    write(*,*) 'Two distinct circles found.'
    write(*,'(A10,F7.4,A1,F7.4)') 'Center1 : ', Center(1,1), ' ', Center(1,2)
    write(*,'(A10,F7.4,A1,F7.4)') 'Center2 : ', Center(2,1), ' ', Center(2,2)
  end if
elseif(Res.lt.0) then
  write(*,*) 'Incorrect value for r.'
end if
write(*,*)
end subroutine print_centers

subroutine test_inputs(P1,P2,R,Res)
implicit none
double precision :: P1(2), P2(2), R, dist
integer :: Res
if(R.lt.0.0d0) then
  Res = -1
  return
elseif(R.eq.0.0d0 .and. P1(1).eq.P2(1) .and. P1(2).eq.P2(2)) then
  Res = 1
  return
elseif(R.eq.0.0d0) then
  Res = 2
  return
elseif(P1(1).eq.P2(1) .and. P1(2).eq.P2(2)) then
  Res = 3
  return
else
  dist = sqrt( (P1(1)-P2(1))**2 + (P1(2)-P2(2))**2 )
  if(dist.gt.2.0d0*R) then
    Res = 4
    return
  else
    Res = 0
    return
  end if
end if
end subroutine test_inputs

subroutine find_center(P1,P2,R,Center)
implicit none
double precision :: P1(2), P2(2), MP(2), Center(2,2), R, dm, dd
MP = (P1 + P2)/2.0d0
dm = sqrt((P1(1) - P2(1))**2 + (P1(2) - P2(2))**2)
dd = sqrt(R**2 - (dm/2.0d0)**2)
Center(1,1) = MP(1) - dd*(P2(2) - P1(2))/dm
Center(1,2) = MP(2) + dd*(P2(1) - P1(1))/dm

Center(2,1) = MP(1) + dd*(P2(2) - P1(2))/dm
Center(2,2) = MP(2) - dd*(P2(1) - P1(1))/dm
end subroutine find_center
