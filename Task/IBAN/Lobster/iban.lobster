let cc = ["AD","AE","AL","AO","AT","AZ","BA","BE","BF","BG","BH","BI","BJ","BR","CG","CH","CI","CM","CR","CV","CY",
          "CZ","DE","DK","DO","DZ","EE","EG","ES","FI","FO","FR","GA","GB","GE","GI","GL","GR","GT","HR","HU","IE",
          "IL","IR","IS","IT","JO","KW","KZ","LB","LI","LT","LU","LV","MC","MD","ME","MG","MK","ML","MR","MT","MU",
          "MZ","NL","NO","PK","PL","PS","PT","QA","RO","RS","SA","SE","SI","SK","SM","SN","TN","TR","UA","VG"]
let ln = [ 24,  23,  28,  25,  20,  28,  20,  16,  27,  22,  22,  16,  28,  29,  27,  21,  28,  27,  21,  25,  28,
           24,  22,  18,  28,  24,  20,  27,  24,  18,  18,  27,  27,  22,  22,  23,  18,  27,  28,  21,  28,  22,
           23,  26,  26,  27,  30,  30,  20,  28,  21,  20,  20,  21,  27,  24,  22,  27,  19,  28,  27,  31,  30,
           25,  18,  15,  24,  28,  29,  25,  29,  24,  22,  24,  24,  19,  24,  27,  28,  24,  26,  29,  24 ]

def ccToLen(s: string) -> int:
    let cnt, idx = binary_search(cc, s.substring(0, 2))
    if cnt == 1:
        return ln[idx]
    else:
        return -1

def strip(s: string) -> string:
    let t = s.tokenize(" ", " ") // splits on spaces and trims spaces from segments
    return t.concat_string("")   // joins it back together

def rotmod97step(accumu: int, c: int) -> int:
    accumu *= 10
    if '0' <= c and c <= '9':
        accumu += c - '0'
    else: if 'A' <= c and c <= 'Z':
        accumu *= 10
        accumu += c + 10 - 'A'
    else:
        return -1
    while accumu >= 97:
        accumu -= 97
    return accumu

def rotmod97(s: string) -> int:
    // the first four chars come last
    // all chars from 'A' to 'Z' => "10" to "35"
    let len = s.length
    var accumu = 0 // result; negative indicates error
    var i = 4 // starting index
    while i < len and accumu >= 0:
        accumu = rotmod97step(accumu, s[i])
        i += 1
    i = 0
    while i < 4 and accumu >= 0:
        accumu = rotmod97step(accumu, s[i])
        i += 1
    return accumu

def isValidIBAN(iban: string) -> bool:
    let s = strip(uppercase(iban))
    if s.length == ccToLen(s):
        return rotmod97(s) == 1
    else:
        return false

assert     isValidIBAN("GB82 WEST 1234 5698 7654 32")
assert     isValidIBAN("GB82 West 1234 5698 7654 32")
assert not isValidIBAN("GB82 TEST 1234 5698 7654 32")
assert not isValidIBAN("GB82 WEST 1243 5698 7654 32")
