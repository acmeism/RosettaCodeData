import algorithm, parseutils, strformat, strutils

const Digits = "0123456789"

#---------------------------------------------------------------------------------------------------

func deBruijn(k, n: int): string =
  let alphabet = Digits[0..<k]
  var a = newSeq[byte](k * n)
  var sequence: seq[byte]

  #.................................................................................................

  func db(t, p: int) =
    if t > n:
      if n mod p == 0:
        sequence &= a[1..p]
    else:
      a[t] = a[t - p]
      db(t + 1, p)
      var j = a[t - p] + 1
      while j < k.uint:
        a[t] = j
        db(t + 1, t)
        inc j

    #...............................................................................................

  db(1, 1)
  for i in sequence:
    result &= alphabet[i]
  result &= result[0..(n-2)]

#---------------------------------------------------------------------------------------------------

proc validate(db: string) =

  var found: array[10_000, int]
  var errs: seq[string]

  ## Check all strings of 4 consecutive digits within 'db'
  ## to see if all 10,000 combinations occur without duplication.
  for i in 0..(db.len - 4):
    let s = db[i..(i+3)]
    var n: int
    if s.parseInt(n) == 4:
      inc found[n]

  for n, count in found:
    if count == 0:
      errs &= fmt"    PIN number {n:04d} missing"
    elif count > 1:
      errs &= fmt"    PIN number {n:04d} occurs {count} times"

  if errs.len == 0:
    echo "  No errors found"
  else:
    let plural = if errs.len == 1: "" else: "s"
    echo fmt"  {errs.len} error{plural} found"
    for err in errs: echo err

#———————————————————————————————————————————————————————————————————————————————————————————————————

var db = deBruijn(10, 4)

echo fmt"The length of the de Bruijn sequence is {db.len}"
echo ""
echo fmt"The first 130 digits of the de Bruijn sequence are: {db[0..129]}"
echo ""
echo fmt"The last 130 digits of the de Bruijn sequence are: {db[^130..^1]}"
echo ""

echo "Validating the deBruijn sequence:"
db.validate()
echo ""
echo "Validating the reversed deBruijn sequence:"
reversed(db).join().validate()
echo ""

db[4443] = '.'
echo "Validating the overlaid deBruijn sequence:"
db.validate()
