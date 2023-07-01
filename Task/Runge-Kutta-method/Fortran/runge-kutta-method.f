program rungekutta
    implicit none
    integer, parameter :: dp = kind(1d0)
    real(dp) :: t, dt, tstart, tstop
    real(dp) :: y, k1, k2, k3, k4

    tstart = 0.0d0
    tstop = 10.0d0
    dt = 0.1d0
    y = 1.0d0
    t = tstart
    write (6, '(a,f4.1,a,f12.8,a,es13.6)') 'y(', t, ') = ', y, ' error = ', &
        abs(y-(t**2+4)**2/16)
    do while (t < tstop)
        k1 = dt*f(t, y)
        k2 = dt*f(t+dt/2, y+k1/2)
        k3 = dt*f(t+dt/2, y+k2/2)
        k4 = dt*f(t+dt, y+k3)
        y = y+(k1+2*(k2+k3)+k4)/6
        t = t+dt
        if (abs(nint(t)-t) <= 1d-12) then
            write (6, '(a,f4.1,a,f12.8,a,es13.6)') 'y(', t, ') = ', y, ' error = ', &
                abs(y-(t**2+4)**2/16)
        end if
    end do
contains
    function f(t,y)
        real(dp), intent(in) :: t, y
        real(dp) :: f

        f = t*sqrt(y)
    end function f
end program rungekutta
