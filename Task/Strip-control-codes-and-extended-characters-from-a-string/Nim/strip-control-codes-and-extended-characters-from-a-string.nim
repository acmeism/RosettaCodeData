proc stripped(str: string): string =
  result = ""
  for c in str:
    if ord(c) in 32..126:
      result.add c

proc strippedControl(str: string): string =
  result = ""
  for c in str:
    if ord(c) in {32..126, 128..255}:
      result.add c

echo strippedControl "\ba\x00b\n\rc\fdÄ"
echo stripped "\ba\x00b\n\rc\fd\xc3"
