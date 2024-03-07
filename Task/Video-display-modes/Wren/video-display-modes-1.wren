/* Video_display_modes.wren */

class C {
    foreign static xrandr(args)

    foreign static usleep(usec)
}

// query supported display modes
C.xrandr("-q")

C.usleep(3000)

// change display mode to 1368x768
System.print("\nChanging to 1368 x 768 mode.")
C.xrandr("-s 1368x768")

C.usleep(3000)

// change it back again to 1920x1080
System.print("\nReverting to 1920 x 1080 mode.")
C.xrandr("-s 1920x1080")
