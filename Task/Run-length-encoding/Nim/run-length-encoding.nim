import parseutils, strutils

proc compress(input: string): string =
  var
    count = 1
    prev = '\0'

  for ch in input:
    if ch != prev:
      if prev != '\0':
        result.add $count & prev
      count = 1
      prev = ch
    else:
      inc count
  result.add $count & prev

proc uncompress(text: string): string =
  var start = 0
  var count: int
  while true:
    let n = text.parseInt(count, start)
    if n == 0 or start + n >= text.len:
      raise newException(ValueError, "corrupted data.")
    inc start, n
    result.add repeat(text[start], count)
    inc start
    if start == text.len: break


const Text = "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"

echo "Text:         ", Text
let compressed = Text.compress()
echo "Compressed:   ", compressed
echo "Uncompressed: ", compressed.uncompress()
