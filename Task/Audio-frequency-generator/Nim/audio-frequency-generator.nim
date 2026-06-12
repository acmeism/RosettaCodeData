import osproc, strutils

type Waveform {.pure.} = enum
  Sine = (1, "sine")
  Square = (2, "square")
  Sawtooth = (3, "sawtooth")

proc getIntValue(msg: string; minval, maxval: int): int =
  while true:
    stdout.write msg
    stdout.flushFile()
    try:
      result = stdin.readLine.strip().parseInt()
      if result notin minval..maxval:
        echo "Invalid value"
      else:
        return
    except ValueError:
      echo "Error: invalid value."
    except EOFError:
      echo()
      quit "Quitting.", QuitFailure

let freq = getIntValue("Enter frequency in Hz (40 to 10000): ", 40, 10_000)
let vol = getIntValue("Enter volume in dB (1 to 50): ", 1, 50)
let dur = getIntValue("Enter duration in seconds (2 to 10): ", 2, 10)
let kind = Waveform getIntValue("Enter kind (1 = sine, 2 = square, 3 = sawtooth): ", 1, 3)

let args = ["-n", "synth", $dur, $kind, $freq, "vol", $vol, "dB"]
echo execProcess("play", args = args, options = {poStdErrToStdOut, poUsePath})
