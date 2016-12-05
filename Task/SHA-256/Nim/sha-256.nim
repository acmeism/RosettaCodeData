import strutils

const SHA256Len = 32

proc SHA256(d: cstring, n: culong, md: cstring = nil): cstring {.cdecl, dynlib: "libssl.so", importc.}

proc SHA256(s: string): string =
  result = ""
  let s = SHA256(s.cstring, s.len.culong)
  for i in 0 .. < SHA256Len:
    result.add s[i].BiggestInt.toHex(2).toLower

echo SHA256("Rosetta code")
