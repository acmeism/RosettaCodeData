import strutils

proc rot13(c): char =
  case toLower(c)
  of 'a'..'m': chr(ord(c) + 13)
  of 'n'..'z': chr(ord(c) - 13)
  else:        c

for line in stdin.lines:
  for c in line:
    stdout.write rot13(c)
  stdout.write "\n"
