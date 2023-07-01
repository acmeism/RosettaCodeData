import endians, math

const
  SampleRate = 44100
  Duration = 8
  DataLength = SampleRate * Duration
  HdrSize = 44
  FileLen = DataLength + HdrSize - 8
  Bps = 8
  Channels = 1

proc writeUint16(f: File; x: uint16) =
  var x = x
  var y: array[2, byte]
  littleEndian16(y.addr, x.addr)
  let n = f.writeBytes(y, 0, 2)
  doAssert n == 2

proc writeUint32(f: File; x: uint32) =
  var x = x
  var y: array[4, byte]
  littleEndian32(y.addr, x.addr)
  let n = f.writeBytes(y, 0, 4)
  doAssert n == 4


let file = open("notes.wav", fmWrite)

# Wav header.
file.write "RIFF"
file.writeUint32(FileLen)
file.write "WAVE"
file.write "fmt "
file.writeUint32(16)                # length of format data.
file.writeUint16(1)                 # type of format(PCM).
file.writeUint16(Channels)
file.writeUint32(SampleRate)
file.writeUint32(SampleRate * Bps * Channels div 8)
file.writeUint16(Bps * Channels div 8)
file.writeUint16(Bps)
file.write "data"
file.writeUint32(DataLength)        # size of data section.

# Compute and write actual data.
const Freqs = [261.6, 293.6, 329.6, 349.2, 392.0, 440.0, 493.9, 523.3]
for freq in Freqs:
  let omega = 2 * Pi * freq
  for i in 0..<(DataLength div Duration):
    let y = (32 * sin(omega * i.toFloat / SampleRate.toFloat)).toInt
    file.write chr(y.byte)  # Signed int to byte then to char as it’s easier this way.

file.close()
