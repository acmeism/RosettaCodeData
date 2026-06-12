import "os" for Process
import "./long" for ULong
import "./crypto" for Bytes, Sha1, Sha256, Hmac
import "./date" for Date
import "./srandom" for SRandom

var StartTime = null  // time program was started (as a Unix timestamp)

class OneTimePassword {
    construct new(digit, timeStep, baseTime, hashClass) {
        _digit = digit            // length of code generated
        _timeStep = timeStep      // length of each time step for TOTP
        _baseTime = baseTime      // start time for TOTP step calculation (as a Unix timestamp)
        _hashClass = hashClass    // hash class to be used with HMAC
    }

    // Convenience version of above which uses defaults values for all except 'digit' parameter.
    static simple(digit) { new(digit, 30, 0, Sha1) }

    // Returns a HOTP code with the given secret and counter.
    hotp(secret, count) { truncate_(hmacSum_(secret, count)) }

    // Returns a TOTP code calculated with the current time and the given secret.
    totp(secret) { hotp(secret, steps_(timeNow_)) }

    /* private helper methods */

    hmacSum_(secret, count) {
        var msg = ULong.new(count).toBytes[-1..0] // big-endian
        return Bytes.fromHexString(Hmac.digest(secret, msg, Sha1))
    }

    dt_(hs) {
        var offset = hs[-1] & 0xf
        var p = hs[offset...offset+4]
        p[0] = p[0] & 0x7f
        return p
    }

    truncate_(hs) {
        var sbits = dt_(hs)
        var snum = Bytes.toIntBE(sbits)
        var pwr = 10.pow(_digit)
        return snum % pwr
    }

    steps_(now) { ((now - _baseTime)/_timeStep).floor }

    timeNow_ { (StartTime + System.clock).floor }
}

var args = Process.arguments
if (args.count != 1) {
    System.print("Please pass the Unix timestamp when starting the program.")
    return
}
StartTime = Num.fromString(args[0])
var secret = "SOME_SECRET".bytes.toList

// Simple 6-digit HOTP code.
var otp = OneTimePassword.simple(6)
System.print(otp.hotp(secret, 123456))

// Google authenticator style 8-digit TOTP code.
otp = OneTimePassword.simple(8)
System.print(otp.totp(secret))

// Custom 9 digit, 5 second step TOTP starting on midnight 2000-01-01 UTC, using Sha256.
var baseTime = Date.new(2000, 1, 1).unixTime
otp = OneTimePassword.new(9, 5, baseTime, Sha256)
System.print(otp.totp(secret))

// As above using a random, 32 byte, Base32 key
var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567" // for Base32
var randKey = List.filled(32, null)
for (i in 0..31) randKey[i] = alphabet[SRandom.int(32)]
System.print(otp.totp(randKey.join().bytes.toList))
