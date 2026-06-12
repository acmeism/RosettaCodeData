import "./iterate" for Stepped
import "./dynamic" for Enum
import "./fmt" for Fmt

/* external results */
var randrsl = List.filled(256, 0)
var randcnt = 0

/* internal state */
var mm = List.filled(256, 0)
var aa = 0
var bb = 0
var cc = 0

var GOLDEN_RATIO = 0x9e3779b9

var isaac = Fn.new {
    cc = cc + 1    // cc just gets incremented once per 256 results
    bb = bb + cc   // then combined with bb
    for (i in 0..255) {
        var x = mm[i]
        var j = i % 4
        aa = (j == 0) ? aa ^ (aa << 13) :
             (j == 1) ? aa ^ (aa >> 6)  :
             (j == 2) ? aa ^ (aa << 2)  :
             (j == 3) ? aa ^ (aa >> 16) : aa
        aa = aa + mm[(i + 128) % 256]
        var y = mm[(x >> 2) % 256] + aa + bb
        mm[i] = y
        bb = mm[(y >> 10) % 256] + x
        randrsl[i] = bb
    }
    randcnt = 0
}

/* if (flag == true), then use the contents of randrsl to initialize mm. */
var mix = Fn.new { |n|
    n[0] = n[0] ^ (n[1] << 11)
    n[3] = n[3] + n[0]
    n[1] = n[1] + n[2]
    n[1] = n[1] ^ (n[2] >>  2)
    n[4] = n[4] + n[1]
    n[2] = n[2] + n[3]
    n[2] = n[2] ^ (n[3] <<  8)
    n[5] = n[5] + n[2]
    n[3] = n[3] + n[4]
    n[3] = n[3] ^ (n[4] >> 16)
    n[6] = n[6] + n[3]
    n[4] = n[4] + n[5]
    n[4] = n[4] ^ (n[5] << 10)
    n[7] = n[7] + n[4]
    n[5] = n[5] + n[6]
    n[5] = n[5] ^ (n[6] >>  4)
    n[0] = n[0] + n[5]
    n[6] = n[6] + n[7]
    n[6] = n[6] ^ (n[7] <<  8)
    n[1] = n[1] + n[6]
    n[7] = n[7] + n[0]
    n[7] = n[7] ^ (n[0] >>  9)
    n[2] = n[2] + n[7]
    n[0] = n[0] + n[1]
}

var randinit = Fn.new { |flag|
    aa = 0
    bb = 0
    cc = 0
    var n = List.filled(8, GOLDEN_RATIO)
    for (i in 0..3) mix.call(n) // scramble the array

    for (i in Stepped.new(0..255, 8)) {  // fill in mm with messy stuff
        if (flag) {                      // use all the information in the seed
           for (j in 0..7) {
                n[j] = n[j] + randrsl[i + j]
           }
        }
        mix.call(n)
        for (j in 0..7) mm[i + j] = n[j]
    }

    if (flag) {
        /* do a second pass to make all of the seed affect all of mm */
        for (i in Stepped.new(0..255, 8)) {
            for (j in 0..7) n[j] = n[j] + mm[i + j]
            mix.call(n)
            for (j in 0..7) mm[i + j] = n[j]
        }
    }

    isaac.call() // fill in the first set of results
    randcnt = 0  // prepare to use the first set of results
}

var iRandom = Fn.new {
    var r = randrsl[randcnt]
    randcnt = randcnt + 1
    if (randcnt > 255) {
        isaac.call()
        randcnt = 0
    }
    return r & 0xffffffff
}

/* Get a random character (as Num) in printable ASCII range */
var iRandA = Fn.new { (iRandom.call() % 95 + 32)  }

/* Seed ISAAC with a string */
var iSeed = Fn.new { |seed, flag|
    for (i in 0..255) mm[i] = 0
    var m = seed.count
    for (i in 0..255) {
        /* in case seed has less than 256 elements */
        randrsl[i] = (i >= m) ? 0 : seed[i].bytes[0]
    }
    /* initialize ISAAC with seed */
    randinit.call(flag)
}

/* XOR cipher on random stream. Output: ASCII string */
var vernam = Fn.new { |msg|
    var len = msg.count
    var v = List.filled(len, 0)
    var i = 0
    for (b in msg.bytes) {
        v[i] = (iRandA.call() ^ b) & 0xff
        i = i + 1
    }
    return v.map { |b| String.fromByte(b) }.join()
}

/* constants for Caesar */
var MOD = 95
var START = 32

/* cipher modes for Caesar */
var CipherMode = Enum.create("CipherMode", ["ENCIPHER", "DECIPHER", "NONE"])

/* Caesar-shift a printable character */
var caesar = Fn.new { |m, ch, shift, modulo, start|
    var sh = (m == CipherMode.DECIPHER) ? -shift : shift
    var n = (ch - start) + sh
    n = n % modulo
    if (n < 0) n = n + modulo
    return String.fromByte(start + n)
}

/* Caesar-shift a string on a pseudo-random stream */
var caesarStr = Fn.new { |m, msg, modulo, start|
    var sb = ""
    /* Caesar-shift message */
    for (b in msg.bytes) {
        sb = sb + caesar.call(m, b, iRandA.call(), modulo, start)
    }
    return sb
}

var toHexByteString = Fn.new { |s|
    return s.bytes.map { |b| Fmt.swrite("$02X", b) }.join()
}

var msg = "a Top Secret secret"
var key = "this is my secret key"

// Vernam & Caesar ciphertext
iSeed.call(key, true)
var vctx = vernam.call(msg)
var cctx = caesarStr.call(CipherMode.ENCIPHER, msg,  MOD, START)

// Vernam & Caesar plaintext
iSeed.call(key, true)
var vptx = vernam.call(vctx)
var cptx = caesarStr.call(CipherMode.DECIPHER, cctx, MOD, START)

// Program output
System.print("Message : %(msg)")
System.print("Key     : %(key)")
System.print("XOR     : %(toHexByteString.call(vctx))")
System.print("XOR dcr : %(vptx)")
System.print("MOD     : %(toHexByteString.call(cctx))")
System.print("MOD dcr : %(cptx)")
