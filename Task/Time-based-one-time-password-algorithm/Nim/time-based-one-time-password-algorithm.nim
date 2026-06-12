import endians, math, sequtils, std/sha1, times

type

  HashFunc = proc(msg: openArray[char]): seq[char]

  OneTimePassword = object
    digit: int          # Length of code generated.
    timeStep: Duration  # Length of each time step for TOTP.
    baseTime: Time      # The start time for TOTP step calculation.
    hash: HashFunc      # Hash algorithm used with HMAC.


func sha1Hash(msg: openArray[char]): seq[char] =
  mapIt(@(Sha1Digest(secureHash(msg))), char(it))


func `xor`(s: seq[char]; val: byte): seq[char] =
  ## Apply a XOR to the chars of a sequence.
  s.mapIt(char(it.byte xor val))


func hmac(key, msg: openArray[char]; hashFunc: HashFunc; blockSize = 64): seq[char] =
  ## Compute a HMAC for gien key, message, hash function and block size.
  var key = @key
  let paddingNeeded = blockSize - key.len
  if paddingNeeded > 0: key.setLen(blockSize)
  result = hashFunc((key xor 0x5c) & hashFunc((key xor 0x36) & @msg))


func simple(digit: int): OneTimePassword =
  ## Return a new OneTimePassword with the specified HTOP code length,
  ## SHA-1 as the HMAC hash algorithm, the Unix epoch as the base time, and
  ## 30 seconds as the step length.
  doAssert digit in 6..9, "HTOP code length must be in 6..9."
  let step = initDuration(seconds = 30)
  result = OneTimePassword(digit: digit, timeStep: step, baseTime: fromUnix(0), hash: sha1Hash)


func hmacSum(otp: OneTimePassword; secret: openArray[char]; count: uint64): seq[char] =
  var count = count
  var beCount: uint64
  bigEndian64(beCount.addr, count.addr)
  let msg = cast[array[8, char]](beCount)
  result = hmac(secret, msg, otp.hash)


func dt(hs: seq[char]): seq[char] =
  let offset = hs[^1].byte and 0xf
  result = hs[offset..offset+3]
  result[0] = char(result[0].byte and 0x7f)


func truncate(otp: OneTimePassword; hs: seq[char]): uint64 =
  let sbits = dt(hs)
  let snum = sbits[3].uint64 or sbits[2].uint64 shl 8 or
             sbits[1].uint64 shl 16 or sbits[0].uint64 shl 24
  result = snum mod 10u^otp.digit


func hotp(otp: OneTimePassword; secret: openArray[char]; count: uint64): uint64 =
  let hs = otp.hmacSum(secret, count)
  result = otp.truncate(hs)


func steps(otp: OneTimePassword; t: Time): uint64 =
  let elapsed = t - otp.baseTime
  result = uint64(elapsed.inSeconds div otp.timeStep.inSeconds)


proc totp(otp: OneTimePassword; secret: openArray[char]): uint64 =
  ## Return a TOTP code calculated with the current time and the given secret.
  otp.hotp(secret, otp.steps(getTime()))


when isMainModule:

  proc exampleSimple =
    ## Simple 6-digit HOTP code.
    const secret = "SOME_SECRET"
    var counter: uint64 = 123456
    let otp = simple(6)
    let code = otp.hotp(secret, counter)
    echo code
    # Output:
    # 260040

  proc exampleAuthenticator =
    ## Google authenticator style 8-digit TOTP code.
    const secret = "SOME_SECRET"
    let otp = simple(8)
    let code = otp.totp(secret)
    echo code

  echo "Simple:"
  exampleSimple()

  echo "Google authenticator:"
  exampleAuthenticator()
