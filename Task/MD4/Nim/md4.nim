import strutils

const MD4Len = 16

proc MD4(d: cstring, n: culong, md: cstring = nil): cstring {.cdecl, dynlib: "libssl.so", importc.}

proc MD4(s: string): string =
  result = ""
  var s = MD4(s.cstring, s.len.culong)
  for i in 0 .. < MD4Len:
    result.add s[i].BiggestInt.toHex(2).toLower

echo MD4("Rosetta Code")
