import strings
import os
import encoding.binary
import math

const (
    sample_rate = 44100
    duration   = 8
    data_length = sample_rate * duration
    hdr_size    = 44
    file_len    = data_length + hdr_size - 8
)
fn main() {

    // buffers
    mut buf1 := []byte{len:1}
    mut buf2 := []byte{len:2}
    mut buf4 := []byte{len:4}

    // WAV header
    mut sb := strings.new_builder(128)
    sb.write_string("RIFF")
    binary.little_endian_put_u32(mut &buf4, file_len)
    sb.write(buf4)? // file size - 8
    sb.write_string("WAVE")
    sb.write_string("fmt ")
    binary.little_endian_put_u32(mut &buf4, 16)
    sb.write(buf4)? // length of format data (= 16)
    binary.little_endian_put_u16(mut &buf2, 1)
    sb.write(buf2)? // type of format (= 1 (PCM))
    sb.write(buf2)? // number of channels (= 1)
    binary.little_endian_put_u32(mut &buf4, sample_rate)
    sb.write(buf4)? // sample rate
    sb.write(buf4)? // sample rate * bps(8) * channels(1) / 8 (= sample rate)
    sb.write(buf2)? // bps(8) * channels(1) / 8  (= 1)
    binary.little_endian_put_u16(mut &buf2, 8)
    sb.write(buf2)? // bits per sample (bps) (= 8)
    sb.write_string("data")
    binary.little_endian_put_u32(mut &buf4, data_length)
    sb.write(buf4)? // size of data section
    wavhdr := sb.str().bytes()

    // write WAV header
    mut f := os.create("notes.wav")?
    defer {
        f.close()
    }
    f.write(wavhdr)?

    // compute and write actual data
    freqs := [261.6, 293.6, 329.6, 349.2, 392.0, 440.0, 493.9, 523.3]!
    for j in 0..duration {
        freq := freqs[j]
        omega := 2 * math.pi * freq
        for i in 0..data_length/duration {
            y := 32 * math.sin(omega*f64(i)/f64(sample_rate))
            buf1[0] = u8(math.round(y))
            f.write(buf1)?
        }
    }
}
