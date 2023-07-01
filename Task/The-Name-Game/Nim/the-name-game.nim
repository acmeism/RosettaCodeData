import strutils

const
  StdFmt = "$1, $1, bo-b$2\nBanana-fana fo-f$2\nFee-fi-mo-m$2\n$1!"
  WovelFmt = "$1, $1, bo-b$2\nBanana-fana fo-f$2\nFee-fi-mo-m$2\n$1!"
  BFmt = "$1, $1, bo-$2\nBanana-fana fo-f$2\nFee-fi-mo-m$2\n$1!"
  FFmt = "$1, $1, bo-b$2\nBanana-fana fo-$2\nFee-fi-mo-m$2\n$1!"
  MFmt = "$1, $1, bo-b$2\nBanana-fana fo-f$2\nFee-fi-mo-$2\n$1!"

proc lyrics(name: string): string =
  let tail = name[1..^1]
  result = case name[0].toUpperAscii
           of 'A', 'E', 'I', 'O', 'U', 'Y':
             WovelFmt.format(name, name.toLowerAscii)
           of 'B':
             BFmt.format(name, tail)
           of 'F':
             FFmt.format(name, tail)
           of 'M':
             MFmt.format(name, tail)
           else:
             StdFmt.format(name, tail)
  result = result.capitalizeAscii()

for name in ["Gary", "Earl", "Billy", "Felix", "Mary"]:
  echo name.lyrics()
  echo()
