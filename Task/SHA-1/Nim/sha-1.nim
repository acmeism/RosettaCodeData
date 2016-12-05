import strutils

const SHA1Len = 20

proc SHA1(d: cstring, n: culong, md: cstring = nil): cstring {.cdecl, dynlib: "libssl.so", importc.}

proc SHA1(s: string): string =
  result = ""
  var s = SHA1(s.cstring, s.len.culong)
  for i in 0 .. < SHA1Len:
    result.add s[i].BiggestInt.toHex(2).toLower

echo SHA1("Rosetta Code")
