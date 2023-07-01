import std/monotimes, times, os

const A = ["|", "/", "—", "\\"]
stdout.write "$\e[?25l"       # Hide the cursor.
let start = getMonoTime()
while true:
  for s in A:
    stdout.write "$\e[2J"     # Clear terminal.
    stdout.write "$\e[0;0H"   # Place cursor at top left corner.
    for _ in 1..40:
      stdout.write s & ' '
    stdout.flushFile
    os.sleep(250)
  let now = getMonoTime()
  if (now - start).inSeconds >= 5:
    break
echo "$\e[?25h"   # Restore the cursor.
