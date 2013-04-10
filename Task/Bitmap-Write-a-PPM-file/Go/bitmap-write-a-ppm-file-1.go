package raster

import (
    "fmt"
    "io"
    "os"
)

// WriteTo outputs 8-bit P6 PPM format to an io.Writer.
func (b *Bitmap) WritePpmTo(w io.Writer) (err error) {
    // magic number
    if _, err = fmt.Fprintln(w, "P6"); err != nil {
        return
    }

    // comments
    for _, c := range b.Comments {
        if _, err = fmt.Fprintln(w, c); err != nil {
            return
        }
    }

    // x, y, depth
    _, err = fmt.Fprintf(w, "%d %d\n255\n", b.cols, b.rows)
    if err != nil {
        return
    }

    // raster data in a single write
    b3 := make([]byte, 3*len(b.px))
    n1 := 0
    for _, px := range b.px {
        b3[n1] = px.R
        b3[n1+1] = px.G
        b3[n1+2] = px.B
        n1 += 3
    }
    if _, err = w.Write(b3); err != nil {
        return
    }
    return
}

// WriteFile writes to the specified filename.
func (b *Bitmap) WritePpmFile(fn string) (err error) {
    var f *os.File
    if f, err = os.Create(fn); err != nil {
        return
    }
    if err = b.WritePpmTo(f); err != nil {
        return
    }
    return f.Close()
}
