package raster

import (
    "errors"
    "io"
    "io/ioutil"
    "os"
    "regexp"
    "strconv"
)

// ReadFrom constructs a Bitmap object from an io.Reader.
func ReadPpmFrom(r io.Reader) (b *Bitmap, err error) {
    var all []byte
    all, err = ioutil.ReadAll(r)
    if err != nil {
        return
    }
    bss := rxHeader.FindSubmatch(all)
    if bss == nil {
        return nil, errors.New("unrecognized ppm header")
    }
    x, _ := strconv.Atoi(string(bss[3]))
    y, _ := strconv.Atoi(string(bss[6]))
    maxval, _ := strconv.Atoi(string(bss[9]))
    if maxval > 255 {
        return nil, errors.New("16 bit ppm not supported")
    }
    allCmts := append(append(append(bss[1], bss[4]...), bss[7]...), bss[10]...)
    b = NewBitmap(x, y)
    b.Comments = rxComment.FindAllString(string(allCmts), -1)
    b3 := all[len(bss[0]):]
    var n1 int
    for i := range b.px {
        b.px[i].R = byte(int(b3[n1]) * 255 / maxval)
        b.px[i].G = byte(int(b3[n1+1]) * 255 / maxval)
        b.px[i].B = byte(int(b3[n1+2]) * 255 / maxval)
        n1 += 3
    }
    return
}

const (
    // single whitespace character
    ws = "[ \n\r\t\v\f]"
    // isolated comment
    cmt = "#[^\n\r]*"
    // comment sub expression
    cmts = "(" + ws + "*" + cmt + "[\n\r])"
    // number with leading comments
    num = "(" + cmts + "+" + ws + "*|" + ws + "+)([0-9]+)"
)

var rxHeader = regexp.MustCompile("^P6" + num + num + num +
    "(" + cmts + "*" + ")" + ws)
var rxComment = regexp.MustCompile(cmt)

// ReadFile writes binary P6 format PPM from the specified filename.
func ReadPpmFile(fn string) (b *Bitmap, err error) {
    var f *os.File
    if f, err = os.Open(fn); err != nil {
        return
    }
    if b, err = ReadPpmFrom(f); err != nil {
        return
    }
    return b, f.Close()
}
