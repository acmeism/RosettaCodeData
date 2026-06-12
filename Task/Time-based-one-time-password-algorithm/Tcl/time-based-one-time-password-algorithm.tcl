# rfc6238 contains examples of hotp with 8-digit modulus and sha1/sha256/sha512 hmac
#
# these require options handling, perhaps http://wiki.tcl.tk/38965
#
catch {namespace delete ::totp}
namespace eval ::totp {
    package require sha1

    oo::class create totp {
        variable Secret
        variable Interval
        variable Window
        constructor {secret {interval 30} {window 300}} {
            if {![string is digit $interval]} {
                set interval [expr {[clock scan $interval] - [clock scan now]}]
            }
            if {![string is digit $window]} {
                set window [expr {[clock scan $window] - [clock scan now]}]
            }
            if {$window % $interval} {
                throw {TOTP BADARGS} "$window is not a multiple of $interval"
            }
            set window [expr {$window / $interval}]
            set Secret $secret
            set Interval $interval
            set Window $window
        }
        method totp {{when now}} {
            if {![string is integer $when]} {
                set when [clock scan $when]
            }
            set when [expr {$when / $Interval}]
            set bytes [binary format W $when]
            binary scan $bytes H* when
            hotp $Secret $bytes
        }

    }

    proc hotp {secret bytes {length 6}} {
        set hmac [sha1::hmac -bin $secret $bytes]
        set ofs [string index $hmac end]
        binary scan $ofs c ofs
        set ofs [expr {$ofs & 0xf}]
        set chunk [string range $hmac $ofs $ofs+4]
        binary scan $chunk I code
        return [format %0${length}.${length}d [expr {($code & 0x7fffffff) % 10 ** $length}]]

    }

    namespace export *
}
namespace import ::totp::*

if 0 {  ;# tests
    if {[info commands assert] eq ""} {
        proc assert {what} {
            puts [uplevel 1 [list subst $what]]
        }
    }
    totp::totp create t 12345678901234567890
    assert {287082 eq [t totp 59]}

    t destroy
    package require base32
    totp::totp create t [base32::decode AAAAAAAAAAAAAAAA]
    proc google {when} {
        list [t totp [expr {$when-30}]] [t totp $when] [t totp [expr {$when+30}]]
    }
    assert {{306281 553572 304383} eq [google 1400000000]}
}
