import os, strformat, strutils

type LuckyKind {.pure.} = enum Lucky = "lucky", EvenLucky = "evenlucky"

const NoValue = 0   # Indicates that no value have been specified.


####################################################################################################
# Lucky numbers generation.

func initLuckyNumbers(nelems: int; kind: LuckyKind): seq[int] =
  ## Initialize a list of lucky numbers.
  result = newSeqOfCap[int](nelems)
  for i in 0..<nelems:
    var k = i
    for j in countdown(result.high, 1):
      k = k * result[j] div (result[j] - 1)
    result.add 2 * k + 1 + ord(kind)


####################################################################################################
# Printing.

template name(kind: LuckyKind): string =
  if kind == Lucky: "Lucky" else: "Even lucky"

proc printSingle(j: int; kind: LuckyKind) =
  ## Print the lucky number at a given index.
  let luckySeq = initLuckyNumbers(j, kind)
  echo &"{name(kind)} number at index {j} is {luckySeq[j - 1]}"

proc printRange(j, k: int; kind: LuckyKind) =
  ## print the luck numbers in a range of indexes.
  let luckySeq = initLuckyNumbers(k, kind)
  var list = &"{name(kind)} numbers at indexes {j} to {k} are: "
  let start = list.len
  for idx in (j - 1)..(k - 1):
    list.addSep(", ", start)
    list.add $luckySeq[idx]
  echo list

proc printInRange(j, k: int; kind: LuckyKind) =
  ## Print the lucky numbers in a range of values.
  let luckySeq = initLuckyNumbers(k, kind)  # "k" is greater than needed.
  var list = &"{name(kind)} numbers between {j} to {k} are: "
  let start = list.len
  for val in luckySeq:
    if val > k: break
    if val > j:
      list.addSep(", ", start)
      list.add $val
  echo list


####################################################################################################
# Command line parsing.

proc parseCommandLine(): tuple[j, k: int; kind: LuckyKind] =
  ## Parse the command line.

  # Internal exception to catch invalid argument value.
  type InvalidArgumentError = object of ValueError

  template raiseError(message, value = "") =
    ## Raise an InvalidArgumentError.
    raise newException(InvalidArgumentError, message & value & '.')


  result = (Novalue, Novalue, Lucky)

  try:

    if paramCount() notin 1..3: raiseError "Wrong number of arguments"

    # First argument: "j" value.
    let p1 = paramStr(1)
    try:
      result.j = parseInt(p1)
      if result.j <= 0: raiseError "Expected a positive number, got: ", p1
    except ValueError:
      raiseError "Expected an integer, got: ", p1

    # Second argument: "k" value or a comma.
    if paramCount() > 1:
      let p2 = paramStr(2)
      if p2 == ",":
        # Must be followed by the kind of lucky number.
        if paramCount() != 3: raiseError "Missing kind argument"
      else:
        try:
          result.k = parseInt(p2)
          if result.k == 0: raiseError "Expected a non null number, got: ", p2
        except ValueError:
          raiseError "Expected an integer, got: ", p2

    # Third argument: number kind.
    if paramCount() == 3:
      let p3 = paramStr(3)
      try:
        result.kind = parseEnum[LuckyKind](p3.toLowerAscii())
      except ValueError:
        raiseError "Wrong kind: ", p3

  except InvalidArgumentError:
    quit getCurrentExceptionMsg()


#———————————————————————————————————————————————————————————————————————————————————————————————————
# Main program.

let (j, k, kind) = parseCommandLine()

if k == NoValue:
  # Print jth value.
  printSingle(j, kind)

elif k > 0:
  # Print jth to kth values.
  printRange(j, k, kind)

else:
  # Print values in range j..(-k).
  printInRange(j, -k, kind)
