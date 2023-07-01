import asyncdispatch, options, strutils
type
  Printer = ref object
    inkLevel, id: int
    backup: Option[Printer]
  OutOfInkException = object of IOError
proc print(p: Printer, line: string){.async.} =
  if p.inkLevel <= 0:
    if p.backup.isNone():
      raise newException(OutOfInkException, "out of ink")
    else:
      await p.backup.get().print(line)
  else:
    p.inkLevel-=1
    stdout.writeLine("$1:$2".format(p.id, line))
    await sleepAsync(100)
proc newPrinter(inkLevel, id: int, backup: Option[Printer]): Printer =
  new(result)
  result.inkLevel = inkLevel
  result.id = id
  result.backup = backup

proc print(p: Printer, msg: seq[string]){.async.} =
  for line in msg:
    try:
      await p.print(line)
    except OutOfInkException as e:
      echo("out of ink")
      break
const
  humptyLines = @[
    "Humpty Dumpty sat on a wall.",
    "Humpty Dumpty had a great fall.",
    "All the king's horses and all the king's men,",
    "Couldn't put Humpty together again.",
    ]
  gooseLines = @[
        "Old Mother Goose,",
        "When she wanted to wander,",
        "Would ride through the air,",
        "On a very fine gander.",
        "Jack's mother came in,",
        "And caught the goose soon,",
        "And mounting its back,",
        "Flew up to the moon.",
    ]
proc main(){.async.} =
  var
    reservePrinter = newPrinter(5, 2, none(Printer))
    mainPrinter = newPrinter(5, 1, some(reservePrinter))
  await mainPrinter.print(gooseLines) and mainPrinter.print(humptyLines)

waitFor main()
