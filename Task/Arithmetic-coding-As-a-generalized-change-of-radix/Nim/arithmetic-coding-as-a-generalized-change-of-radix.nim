import strformat, sugar, tables
import bignum

type Freq = CountTable[char]


proc cumulativeFreq(freq: Freq): Freq =
  var total = 0
  for c in '\0'..'\255':
    result.inc c, total
    inc total, freq[c]


func arithmeticCoding(str: string; radix: int): (Int, int, Freq) =

  let freq = str.toCountTable()   # The frequency characters.
  let cf = cumulativeFreq(freq)   # The cumulative frequency.
  let base = newInt(str.len)      # Base.
  var lower = newInt(0)           # Lower bound.
  var pf = newInt(1)              # Product of all frequencies.

  # Each term is multiplied by the product of the
  # frequencies of all previously occurring symbols.
  for c in str:
    lower = lower * base + cf[c] * pf
    pf *= freq[c]

  let upper = lower + pf          # Upper bound.
  var powr = 0

  while true:
    pf = pf div radix
    if pf.isZero: break
    inc powr

  let diff = (upper - 1) div radix.pow(powr.culong)
  result = (diff, powr, freq)


func arithmeticDecoding(num: Int; radix, pwr: int; freq: Freq): string =
  var enc = num * radix.pow(pwr.culong)
  var base = 0
  for v in freq.values: base += v

  # Create the cumulative frequency table.
  let cf = cumulativeFreq(freq)

  # Create the dictionary.
  let dict = collect(newTable, for k in '\0'..'\255': {cf[k]: k})

  # Fill the gaps in the dictionary.
  var lchar = -1
  for i in 0..<base:
    if i in dict:
      lchar = ord(dict[i])
    elif lchar >= 0:
      dict[i] = chr(lchar)

  # Decode the input number.
  for i in countdown(base - 1, 0):
    let p = base.pow(i.culong)
    let d = enc div p
    let c = dict[d.toInt]
    let diff = enc - p * cf[c]
    enc = diff div freq[c]
    result.add c


const Radix = 10
const Strings = ["DABDDB", "DABDDBBDDBA", "ABRACADABRA", "TOBEORNOTTOBEORTOBEORNOT"]
for str in Strings:
  let (enc, pow, freq) = arithmeticCoding(str, Radix)
  let dec = arithmeticDecoding(enc, Radix, pow, freq)
  echo &"{str:<25}→ {enc:>19} * {Radix}^{pow}"
  doAssert str == dec, "\tHowever that is incorrect!"
