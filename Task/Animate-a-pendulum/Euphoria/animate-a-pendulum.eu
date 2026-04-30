include graphics.e
include misc.e

constant dt = 1E-3
constant g = 50

sequence vc
sequence suspension
atom len

procedure draw_pendulum(atom color, atom len, atom alfa)
    sequence point
    point = (len*{sin(alfa),cos(alfa)} + suspension)
    draw_line(color, {suspension, point})
    ellipse(color,0,point-{10,10},point+{10,10})
end procedure

function wait()
    atom t0
    t0 = time()
    while time() = t0 do
        if get_key() != -1 then
            return 1
        end if
    end while
    return 0
end function

procedure animation()
    atom alfa, omega, epsilon

    if graphics_mode(18) then
    end if

    vc = video_config()
    suspension = {vc[VC_XPIXELS]/2,vc[VC_YPIXELS]/2}
    len = vc[VC_YPIXELS]/2-20

    alfa = PI/2
    omega = 0

    while 1 do
        draw_pendulum(BRIGHT_WHITE,len,alfa)
        if wait() then
            exit
        end if
        draw_pendulum(BLACK,len,alfa)
        epsilon = -len*sin(alfa)*g
        omega += dt*epsilon
        alfa += dt*omega
    end while

    if graphics_mode(-1) then
    end if
end procedure

animation()
