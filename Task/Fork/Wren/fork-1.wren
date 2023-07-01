/* fork.wren */

class C {
    foreign static fork()

    foreign static usleep(usec)

    foreign static wait()
}

var pid = C.fork()
if (pid == 0) {
    C.usleep(10000)
    System.print("\tchild process: done")
} else if (pid < 0) {
    System.print("fork error")
} else {
    System.print("waiting for child %(pid)...")
    System.print("child %(C.wait()) finished")
}
