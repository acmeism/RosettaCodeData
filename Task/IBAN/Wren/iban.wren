import "/big" for BigInt

var countryCodes =
    "AD24 AE23 AL28 AT20 AZ28 BA20 BE16 BG22 BH22 BR29 " +
    "BY28 CH21 CR22 CY28 CZ24 DE22 DK18 DO28 EE20 ES24 " +
    "FI18 FO18 FR27 GB22 GE22 GI23 GL18 GR27 GT28 HR21 " +
    "HU28 IE22 IL23 IQ23 IS26 IT27 JO30 KW30 KZ20 LB28 " +
    "LC32 LI21 LT20 LU20 LV21 MC27 MD24 ME22 MK19 MR27 " +
    "MT31 MU30 NL18 NO15 PK24 PL28 PS29 PT25 QA29 RO24 " +
    "RS22 SA24 SC31 SE24 SI19 SK24 SM27 ST25 SV28 TL23 " +
    "TN24 TR26 UA29 VG24 XK20"

var isValid = Fn.new { |iban|
    // remove spaces from IBAN
    var s = iban.replace(" ", "")

    // check country code and length
    if (!countryCodes.contains(s[0..1] + s.count.toString)) return false

    // move first 4 characters to the end
    s = s[4..-1] + s[0..3]

    // replace A to Z with numbers 10 To 35
    var i = 10
    for (c in "ABCDEFGHIJKLMNOPQRSTUVWXYZ") {
        s = s.replace(c, i.toString)
        i = i + 1
    }

    // check whether mod 97 calculation gives a remainder of 1
    return (BigInt.new(s) % BigInt.new(97)) == BigInt.one
}

var ibans = [ "GB82 WEST 1234 5698 7654 32", "GB82 TEST 1234 5698 7654 32" ]
for (iban in ibans) {
    var valid = isValid.call(iban)
    System.print(iban + (valid ? " may be valid" : " is not valid"))
}
