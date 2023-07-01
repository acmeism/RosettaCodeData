import std/[strformat, strutils]

func twosComplement[T: SomeSignedInt](n: T): T =
  ## Compute the two's complement of "n".
  not n + 1

echo &"""{"n":^15}{"2's complement":^15}{"-n":^15}"""
for n in [0i32, 1i32, -1i32]:
  echo &"{n.toHex:^15}{twosComplement(n).toHex:^15}{(-n).toHex:^15}"
for n in [-50i8, 50i8]:
  echo &"{n.toHex:^15}{twosComplement(n).toHex:^15}{(-n).toHex:^15}"
