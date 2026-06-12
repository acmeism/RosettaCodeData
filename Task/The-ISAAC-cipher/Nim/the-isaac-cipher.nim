import strutils

type

  IMode = enum iEncrypt, iDecrypt

  State = object
    # Internal.
    mm: array[256, uint32]
    aa, bb, cc: uint32
    # External.
    randrsl: array[256, uint32]
    randcnt: uint32


proc isaac(s: var State) =

  inc s.cc        # "cc" just gets incremented once per 256 results
  s.bb += s.cc    # then combined with "bb".

  for i in 0u32..255:
    let x = s.mm[i]
    case range[0..3](i and 3)
    of 0: s.aa = s.aa xor s.aa shl 13
    of 1: s.aa = s.aa xor s.aa shr 6
    of 2: s.aa = s.aa xor s.aa shl 2
    of 3: s.aa = s.aa xor s.aa shr 16
    s.aa += s.mm[(i + 128) and 255]
    let y = s.mm[(x shr 2) and 255] + s.aa + s.bb
    s.mm[i] = y
    s.bb = s.mm[(y shr 10) and 255] + x
    s.randrsl[i] = s.bb

  s.randcnt = 0


proc mix(a: var array[8, uint32]) =
  a[0] = a[0] xor a[1] shl 11; a[3] += a[0]; a[1] += a[2]
  a[1] = a[1] xor a[2] shr  2; a[4] += a[1]; a[2] += a[3]
  a[2] = a[2] xor a[3] shl  8; a[5] += a[2]; a[3] += a[4]
  a[3] = a[3] xor a[4] shr 16; a[6] += a[3]; a[4] += a[5]
  a[4] = a[4] xor a[5] shl 10; a[7] += a[4]; a[5] += a[6]
  a[5] = a[5] xor a[6] shr  4; a[0] += a[5]; a[6] += a[7]
  a[6] = a[6] xor a[7] shl  8; a[1] += a[6]; a[7] += a[0]
  a[7] = a[7] xor a[0] shr  9; a[2] += a[7]; a[0] += a[1]


proc iRandInit(s: var State; flag: bool) =

  s.aa = 0; s.bb = 0; s.cc = 0
  var a: array[8, uint32]
  for item in a.mitems: item = 0x9e3779b9u32  # The golden ratio.

  for i in 0..3:  # Scramble it.
    a.mix()

  var i = 0u32
  while true:   # Fill in "mm" with messy stuff.
    if flag:
      # Use all the information in the seed.
      for n in 0u32..7: a[n] += s.randrsl[n + i]
    a.mix()
    for n in 0u32..7: s.mm[n + i] = a[n]
    inc i, 8
    if i > 255: break

  if flag:
    # Do a second pass to make all of the seed affect all of "mm".
    i = 0
    while true:
      for n in 0u32..7: a[n] += s.mm[n + i]
      a.mix()
      for n in 0u32..7: s.mm[n + i] = a[n]
      inc i, 8
      if i > 255: break

  s.isaac()       # Fill in the first set of results.
  s.randcnt = 0   # Prepare to use the first set of results.


proc iSeed(s: var State; seed: string; flag: bool) =
  ## Seed ISAAC with a given string.
  ## The string can be any size. The first 256 values will be used.
  s.mm.reset()
  let m = seed.high
  for i in 0..255:
    s.randrsl[i] = if i > m: 0 else: ord(seed[i])
  # Initialize ISAAC with seed.
  s.iRandInit(flag)


proc iRandom(s: var State): uint32 =
  ## Get a random 32-bit value 0..int32.high.
  result = s.randrsl[s.randcnt]
  inc s.randcnt
  if s.randcnt > 255:
    s.isaac()
    s.randcnt = 0


proc iRandA(s: var State): byte =
  ## Get a random character in printable ASCII range.
  result = byte(s.iRandom() mod 95 + 32)


proc vernam(s: var State; msg: string): string =
  ## XOR encrypt on random stream. Output: ASCII string.
  result.setLen(msg.len)
  for i, c in msg:
    result[i] = chr(s.irandA() xor byte(c))


template letterNum(letter, start: char): int =
  ord(letter) - ord(start)


proc caesar(m: IMode; ch: char; shift, modulo: int; start: char): char =
  let shift = if m == iEncrypt: shift else: -shift
  var n = letterNum(ch, start) + shift
  n = n mod modulo
  if n < 0: inc n, modulo
  result = chr(ord(start) + n)


proc vigenere(s: var State; msg: string; m: IMode): string =
  ## Vigenere MOD 95 encryption & decryption. Output: ASCII string.
  result.setLen(msg.len)
  for i, c in msg:
    result[i] = caesar(m, c, s.iRanda().int, 95, ' ')


let
  msg = "a Top Secret secret"
  key = "this is my secret key"

var state: State

# 1) seed ISAAC with the key
state.iSeed(key, true)
# 2) Encryption
# a) XOR (Vernam)
let xctx = state.vernam(msg)                # XOR ciphertext.
# b) MOD (Vigenere)
let mctx = state.vigenere(msg, iEncrypt)    # MOD ciphertext.
# 3) Decryption
state.iSeed(key, true)
# a) XOR (Vernam)
let xptx = state.vernam(xctx)               # XOR decryption (plaintext).
# b) MOD (Vigenere)
let mptx = state.vigenere(mctx, iDecrypt)   # MOD decryption (plaintext).
# Program output
echo "Message: ", msg
echo "    Key: ", key
echo "    XOR: ", xctx.tohex
echo "    MOD: ", mctx.toHex
echo "XOR dcr: ", xptx
echo "MOD dcr: ", mptx
