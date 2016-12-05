proc stripped(str): string =
  result = ""
  for c in str:
    if ord(c) in 32..126:
      result.add c

echo stripped "\ba\x00b\n\rc\fd\xc3"
