package main

import (
    ed "github.com/Ernyoke/Imger/edgedetection"
    "github.com/Ernyoke/Imger/imgio"
    "log"
)

func main() {
    img, err := imgio.ImreadRGBA("Valve_original_(1).png")
    if err != nil {
        log.Fatal("Could not read image", err)
    }

    cny, err := ed.CannyRGBA(img, 15, 45, 5)
    if err != nil {
        log.Fatal("Could not perform Canny Edge detection")
    }

    err = imgio.Imwrite(cny, "Valve_canny_(1).png")
    if err != nil {
        log.Fatal("Could not write Canny image to disk")
    }
}
