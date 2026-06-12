package main

import (
    "encoding/binary"
    "fmt"
    "log"
    "math"
    "os"
)

var (
    freqs = []float64{261.6, 293.6, 329.6, 349.2, 392.0, 440.0, 493.9, 523.3}
    notes = []string{"Doh", "Ray", "Mee", "Fah", "Soh", "Lah", "Tee", "doh"}
)

func getNote(freq float64) string {
    index := len(freqs)
    for i := 0; i < len(freqs); i++ {
        if freq <= freqs[i] {
            index = i
            break
        }
    }
    switch index {
    case 0:
        return "Doh-"
    case len(freqs):
        return "doh+"
    default:
        if freqs[index]-freq <= freq-freqs[index-1] {
            return notes[index] + "-"
        }
        return notes[index-1] + "+"
    }
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func main() {
    file, err := os.Open("notes.wav")
    check(err)
    defer file.Close()
    hdr := make([]byte, 44)
    _, err = file.Read(hdr)
    check(err)
    // check header parameters
    sampleRate := int(binary.LittleEndian.Uint32(hdr[24:28]))
    fmt.Println("Sample Rate    :", sampleRate)
    dataLength := int(binary.LittleEndian.Uint32(hdr[40:]))
    duration := dataLength / sampleRate
    fmt.Println("Duration       :", duration)

    sum := 0.0
    sampleRateF := float64(sampleRate)
    data := make([]byte, sampleRate)
    nbytes := 20
    fmt.Println("Bytes examined :", nbytes, "per sample")
    for j := 0; j < duration; j++ {
        _, err := file.Read(data)
        check(err)
        for i := 1; i <= nbytes; i++ {
            bf := float64(data[i]) / 32
            freq := math.Asin(bf) * sampleRateF / (float64(i) * math.Pi * 2)
            sum += freq
        }
    }
    cav := sum / (float64(duration) * float64(nbytes))
    fmt.Printf("\nComputed average frequency = %.1f Hz (%s)\n", cav, getNote(cav))

    sum = 0.0
    for i := 0; i < len(freqs); i++ {
        sum += freqs[i]
    }
    aav := sum / float64(len(freqs))
    fmt.Printf("Actual average frequency   = %.1f Hz (%s)\n", aav, getNote(aav))
}
