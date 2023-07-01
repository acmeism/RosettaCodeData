package main

import (
    "github.com/fogleman/gg"
    "log"
    "os/exec"
    "runtime"
)

var palette = [8]string{
    "000000", // black
    "FF0000", // red
    "00FF00", // green
    "0000FF", // blue
    "FF00FF", // magenta
    "00FFFF", // cyan
    "FFFF00", // yellow
    "FFFFFF", // white
}

func pinstripe(dc *gg.Context) {
    w := dc.Width()
    h := dc.Height() / 7
    for b := 1; b <= 11; b++ {
        for x, ci := 0, 0; x < w; x, ci = x+b, ci+1 {
            dc.SetHexColor(palette[ci%8])
            y := h * (b - 1)
            dc.DrawRectangle(float64(x), float64(y), float64(b), float64(h))
            dc.Fill()
        }
    }
}

func main() {
    dc := gg.NewContext(842, 595)
    pinstripe(dc)
    fileName := "color_pinstripe.png"
    dc.SavePNG(fileName)
    var cmd *exec.Cmd
    if runtime.GOOS == "windows" {
        cmd = exec.Command("mspaint", "/pt", fileName)
    } else {
        cmd = exec.Command("lp", fileName)
    }
    if err := cmd.Run(); err != nil {
        log.Fatal(err)
    }
}
