import endians, math, stats, strformat

const
  Freqs = [261.6, 293.6, 329.6, 349.2, 392.0, 440.0, 493.9, 523.3]
  Notes = ["Doh", "Ray", "Mee", "Fah", "Soh", "Lah", "Tee", "doh"]


func getNote(freq: float): string =
  var index = Freqs.len
  for i, f in Freqs:
    if freq <= f:
      index = i
      break
  result = if index == 0:
             "Doh-"
           elif index == Freqs.len:
             "doh+"
           elif Freqs[index] - freq <= freq - Freqs[index-1]:
             Notes[index] & '-'
           else:
             Notes[index-1] & '+'


proc getUint32(buffer: openArray[byte]; pos: Natural): uint32 =
  littleEndian32(result.addr, buffer[pos].unsafeAddr)


let file = open("notes.wav")
var hdr: array[44, byte]
let n = file.readBytes(hdr, 0, hdr.len)
doAssert n == hdr.len

# Check header parameters.
let sampleRate = hdr.getUint32(24)
echo "Sample rate:    ", sampleRate
let dataLength = hdr.getUint32(40)
let duration = dataLength div sampleRate
echo "Duration:       ", duration

var sum = 0.0
let sampleRateF = float(sampleRate)
var data = newSeq[byte](sampleRate)
let nbytes = 20
echo "Bytes examined: ", nbytes, " per sample"
for j in 0..<duration:
  let n = file.readBytes(data, 0, data.len)
  doAssert n == data.len
  for i in 1..nbytes:
    let bf = float(data[i]) / 32
    let freq = arcsin(bf) * sampleRateF / (i.toFloat * 2 * Pi)
    sum += freq
let cav = sum / float(duration.int * nbytes)
echo &"\nComputed average frequency = {cav:.1f} Hz ({cav.getNote()})"

let aav = mean(Freqs)
echo &"Actual average frequency   = {aav:.1f} Hz ({aav.getNote()})"
