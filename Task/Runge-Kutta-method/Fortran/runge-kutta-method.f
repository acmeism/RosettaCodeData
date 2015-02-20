program rungekutta
implicit none
real(kind=kind(1.0D0)) :: t,dt,tstart,tstop
real(kind=kind(1.0D0)) :: y,k1,k2,k3,k4
tstart =0.0D0 ; tstop =10.0D0 ; dt = 0.1D0
y = 1.0D0
t = tstart
write(6,'(A,f4.1,A,f12.8,A,es13.6)') 'y(',t,') = ',y,' Error = '&
           &,abs(y-(t**2+4.0d0)**2/16.0d0)
do; if ( t .ge. tstop ) exit
   k1 = f (t           , y                 )
   k2 = f (t+0.5D0 * dt, y +0.5D0 * dt * k1)
   k3 = f (t+0.5D0 * dt, y +0.5D0 * dt * k2)
   k4 = f (t+        dt, y +        dt * k3)
   y = y + dt *( k1 + 2.0D0 *( k2 + k3 ) + k4 )/6.0D0
   t = t + dt
   if(abs(real(nint(t))-t) .le. 1.0D-12) then
      write(6,'(A,f4.1,A,f12.8,A,es13.6)') 'y(',t,') = ',y,' Error = '&
           &,abs(y-(t**2+4.0d0)**2/16.0d0)
   end if
end do
contains
  function f (t,y)
    implicit none
    real(kind=kind(1.0D0)),intent(in) :: y,t
    real(kind=kind(1.0D0)) :: f
    f = t*sqrt(y)
  end function f
end program rungekutta
