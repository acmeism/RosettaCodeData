/* Run_as_a_daemon_or_service.wren */

import "./date" for Date

var O_WRONLY = 1
var O_APPEND = 1024
var O_CREAT  = 64

var STDOUT_FILENO = 1

class C {
    foreign static fileName

    foreign static open(pathName, flags, mode)

    foreign static daemon(nochdir, noclose)

    foreign static redirectStdout(oldfd, newfd)

    foreign static close(fd)

    foreign static time

    foreign static sleep(seconds)
}

// gets a Date object from a Unix time in seconds
var UT2Date = Fn.new { |ut| Date.unixEpoch.addSeconds(ut) }

Date.default = "ddd| |mmm| |dd| |hh|:|MM|:|ss| |yyyy" // default format for printing

// open file before becoming a daemon
var fd = C.open(C.fileName, O_WRONLY | O_APPEND | O_CREAT, 438)
if (fd < 0) {
    System.print("Error opening %(C.fileName)")
    return
}

// become a daemon
if (C.daemon(0, 0) < 0) {
    System.print("Error creating daemon.")
    return
}

// redirect stdout
if (C.redirectStdout(fd, STDOUT_FILENO) < 0) {
    System.print("Error redirecting stdout.")
    return
}

// close file
if (C.close(fd) < 0) {
    System.print("Error closing %(C.fileName)")
    return
}

// dump time every second
while (true) {
    System.print(UT2Date.call(C.time))
    C.sleep(1)
}
