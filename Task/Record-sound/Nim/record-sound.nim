import osproc, strutils

var name = ""
while name.len == 0:
  stdout.write "Enter output file name (without extension): "
  name = stdin.readLine().strip()
name.add ".wav"

var rate = 0
while rate notin 2000..19_200:
  stdout.write "Enter sampling rate in Hz (2000 to 192000): "
  try: rate = parseInt(stdin.readLine().strip())
  except ValueError: discard

var duration = 0
while duration notin 5..30:
  stdout.write "Enter duration in seconds (5 to 30): "
  try: duration = parseInt(stdin.readLine().strip())
  except ValueError: discard

echo "OK, start speaking now..."
# Default arguments: -c 1, -t wav. Note that only signed 16 bit format is supported.
let args = ["-r", $rate, "-f", "S16_LE", "-d", $duration, name]
echo execProcess("arecord", args = args, options = {poStdErrToStdOut, poUsePath})

echo "'$1' created on disk and will now be played back..." % name
echo execProcess("aplay", args = [name], options = {poStdErrToStdOut, poUsePath})
echo "Playback completed"
