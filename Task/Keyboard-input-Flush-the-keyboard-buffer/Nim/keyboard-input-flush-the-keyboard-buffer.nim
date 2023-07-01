const TCIFLUSH: cint = 0
proc tcflush(fd, queue_selector: cint): cint {.header: "termios.h".}

discard tcflush(cint(getFileHandle(stdin)), TCIFLUSH)
