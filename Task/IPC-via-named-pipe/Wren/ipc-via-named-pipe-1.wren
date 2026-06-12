/* IPC_via_named_pipe.wren */

var InputFifo  = "in"
var OutputFifo = "out"

var O_RDONLY = 0
var O_WRONLY = 1

var PIPE_BUF = 4096

class Fifo {
    foreign static make(path, oflag)
}

class File {
    foreign static open(path, flags)

    foreign static write(fd, str, size)

    foreign static read(fd, size)

    foreign static close(fd)
}

class C {
    foreign static usleep(usec)

    foreign static tally
    foreign static tally=(newTally)
}

class Loops {
    static read() {
        while (true) {
            var fd = File.open(InputFifo, O_RDONLY)
            var len
            while ((len = File.read(fd, PIPE_BUF)) > 0) C.tally = C.tally + len
            File.close(fd)
        }
    }

    static write() {
        while (true) {
            var fd = File.open(OutputFifo, O_WRONLY)
            var ts = C.tally.toString + "\n"
            File.write(fd, ts, ts.bytes.count)
            File.close(fd)
            C.usleep(10000)
        }
    }
}

Fifo.make(InputFifo, 438)
Fifo.make(OutputFifo, 438)
