import os, strutils

func extractFileExt(path: string): string =
  var s: seq[char]
  for i in countdown(path.high, 0):
    case path[i]
    of Letters, Digits:
      s.add path[i]
    of '.':
      s.add '.'
      while s.len > 0: result.add s.pop()
      return
    else:
      break
  result = ""

for input in ["http://example.com/download.tar.gz", "CharacterModel.3DS",
              ".desktop", "document", "document.txt_backup", "/etc/pam.d/login"]:
  echo "Input: ", input
  echo "Extracted extension:    ", input.extractFileExt()
  echo "Using standard library: ", input.splitFile()[2]
  echo()
