import strutils

proc isRepeated(text: string): int =
  for x in countdown(text.len div 2, 0):
    if text.startsWith(text[x..text.high]): return x

const matchstr = """1001110011
1110111011
0010010010
1010101010
1111111111
0100101101
0100100
101
11
00
1"""

for line in matchstr.split():
  let ln = isRepeated(line)
  echo "'", line, "' has a repetition length of ", ln, " i.e ",
    (if ln > 0: "'" & line[0 ..< ln] & "'" else: "*not* a rep-string")
