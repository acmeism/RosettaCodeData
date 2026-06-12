import os
import math
import encoding.binary

const (
    freqs = [261.6, 293.6, 329.6, 349.2, 392.0, 440.0, 493.9, 523.3]
    notes = ["Doh", "Ray", "Mee", "Fah", "Soh", "Lah", "Tee", "doh"]
)

fn get_note(freq f64) string {
    mut index := freqs.len
    for i in 0..freqs.len {
        if freq <= freqs[i] {
            index = i
            break
        }
    }
    match index {
		0 {return "Doh-"}
		freqs.len {return "doh+"}
		else {
			if freqs[index]-freq <= freq-freqs[index-1] {return '${notes[index]}-'}
			return "${notes[index-1]}+"
		}
	}
}

fn main() {
    mut file := os.open("notes.wav")!
    defer {file.close()}
    mut hdr := []u8{len: 44}
    file.read(mut &hdr)!

    // check header parameters
    sample_rate := int(binary.little_endian_u32(hdr[24..28]))
    println("Sample Rate    : $sample_rate")
    data_length := int(binary.little_endian_u32(hdr[40..]))
    duration := data_length / sample_rate
    println("Duration       : $duration")

    mut sum := 0.0
    sample_rate_f := f64(sample_rate)
    mut data := []u8{len: sample_rate}
    nbytes := 20
    println("Bytes examined : $nbytes per sample")
    for _ in 0..duration {
        file.read(mut &data)!
        for i := 1; i <= nbytes; i++ {
            bf := f64(data[i]) / 32
            freq := math.asin(bf) * sample_rate_f / (f64(i) * math.pi * 2)
            sum += freq
        }
    }
    cav := sum / (f64(duration) * f64(nbytes))
    println("\nComputed average frequency = ${cav:.1} Hz (${get_note(cav)})")

    sum = 0.0
    for i in 0..freqs.len {
        sum += freqs[i]
    }
    aav := sum / f64(freqs.len)
    println("Actual average frequency   = ${aav:.1} Hz (${get_note(aav)})")
}
