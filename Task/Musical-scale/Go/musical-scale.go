package main

import (
    "encoding/binary"
    "log"
    "math"
    "os"
    "strings"
)

func main() {
    const (
        sampleRate = 44100
        duration   = 8
        dataLength = sampleRate * duration
        hdrSize    = 44
        fileLen    = dataLength + hdrSize - 8
    )

    // buffers
    buf1 := make([]byte, 1)
    buf2 := make([]byte, 2)
    buf4 := make([]byte, 4)

    // WAV header
    var sb strings.Builder
    sb.WriteString("RIFF")
    binary.LittleEndian.PutUint32(buf4, fileLen)
    sb.Write(buf4) // file size - 8
    sb.WriteString("WAVE")
    sb.WriteString("fmt ")
    binary.LittleEndian.PutUint32(buf4, 16)
    sb.Write(buf4) // length of format data (= 16)
    binary.LittleEndian.PutUint16(buf2, 1)
    sb.Write(buf2) // type of format (= 1 (PCM))
    sb.Write(buf2) // number of channels (= 1)
    binary.LittleEndian.PutUint32(buf4, sampleRate)
    sb.Write(buf4) // sample rate
    sb.Write(buf4) // sample rate * bps(8) * channels(1) / 8 (= sample rate)
    sb.Write(buf2) // bps(8) * channels(1) / 8  (= 1)
    binary.LittleEndian.PutUint16(buf2, 8)
    sb.Write(buf2) // bits per sample (bps) (= 8)
    sb.WriteString("data")
    binary.LittleEndian.PutUint32(buf4, dataLength)
    sb.Write(buf4) // size of data section
    wavhdr := []byte(sb.String())

    // write WAV header
    f, err := os.Create("notes.wav")
    if err != nil {
        log.Fatal(err)
    }
    defer f.Close()
    f.Write(wavhdr)

    // compute and write actual data
    freqs := [8]float64{261.6, 293.6, 329.6, 349.2, 392.0, 440.0, 493.9, 523.3}
    for j := 0; j < duration; j++ {
        freq := freqs[j]
        omega := 2 * math.Pi * freq
        for i := 0; i < dataLength/duration; i++ {
            y := 32 * math.Sin(omega*float64(i)/float64(sampleRate))
            buf1[0] = byte(math.Round(y))
            f.Write(buf1)
        }
    }
}
