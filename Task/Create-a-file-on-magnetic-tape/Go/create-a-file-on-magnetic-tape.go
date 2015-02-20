package main

import (
        "archive/tar"
        "compress/gzip"
        "flag"
        "io"
        "log"
        "os"
        "time"
)

func main() {
        filename := flag.String("file", "TAPE.FILE", "filename within TAR")
        data := flag.String("data", "", "data for file")
        outfile := flag.String("out", "", "output file or device (e.g. /dev/tape)")
        gzipFlag := flag.Bool("gzip", false, "use gzip compression")
        flag.Parse()

        var w io.Writer = os.Stdout
        if *outfile != "" {
                f, err := os.Create(*outfile)
                if err != nil {
                        log.Fatalf("opening/creating %q: %v", *outfile, err)
                }
                defer f.Close()
                w = f
        }

        if *gzipFlag {
                zw := gzip.NewWriter(w)
                defer zw.Close()
                w = zw
        }

        tw := tar.NewWriter(w)
        defer tw.Close()
        w = tw
        tw.WriteHeader(&tar.Header{
                Name:     *filename,
                Mode:     0660,
                Size:     int64(len(*data)),
                ModTime:  time.Now(),
                Typeflag: tar.TypeReg,
                Uname:    "guest",
                Gname:    "guest",
        })

        _, err := w.Write([]byte(*data))
        if err != nil {
                log.Fatal("writing data:", err)
        }
}
