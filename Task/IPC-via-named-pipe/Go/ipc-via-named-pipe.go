package main

import (
        "fmt"
        "io"
        "log"
        "os"
        "sync/atomic"
        "syscall"
)

const (
        inputFifo  = "/tmp/in.fifo"
        outputFifo = "/tmp/out.fifo"
        readsize   = 64 << 10
)

func openFifo(path string, oflag int) (f *os.File, err error) {
        err = syscall.Mkfifo(path, 0660)
        // We'll ignore "file exists" errors and assume the FIFO was pre-made
        if err != nil && !os.IsExist(err) {
                return
        }
        f, err = os.OpenFile(path, oflag, 0660)
        if err != nil {
                return
        }
        // In case we're using a pre-made file, check that it's actually a FIFO
        fi, err := f.Stat()
        if err != nil {
                f.Close()
                return nil, err
        }
        if fi.Mode()&os.ModeType != os.ModeNamedPipe {
                f.Close()
                return nil, os.ErrExist
        }
        return
}

func main() {
        var byteCount int64
        go func() {
                var delta int
                var err error
                buf := make([]byte, readsize)
                for {
                        input, err := openFifo(inputFifo, os.O_RDONLY)
                        if err != nil {
                                break
                        }
                        for err == nil {
                                delta, err = input.Read(buf)
                                atomic.AddInt64(&byteCount, int64(delta))
                        }
                        input.Close()
                        if err != io.EOF {
                                break
                        }
                }
                log.Fatal(err)
        }()

        for {
                output, err := openFifo(outputFifo, os.O_WRONLY)
                if err != nil {
                        log.Fatal(err)
                }
                cnt := atomic.LoadInt64(&byteCount)
                fmt.Fprintln(output, cnt)
                output.Close()
        }
}
