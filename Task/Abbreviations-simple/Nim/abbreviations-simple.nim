import parseutils
import strutils
import tables

const Commands =
  "add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3 " &
  "compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate " &
  "3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2 " &
  "forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load " &
  "locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2 " &
  "msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3 " &
  "refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left " &
  "2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1"

#---------------------------------------------------------------------------------------------------

proc abbrevationLengths(commands: string): Table[string, int] =
  ## Find the minimal abbreviation length for each word.
  ## A word that does not have minimum abbreviation length specified
  ## gets it's full length as the minimum.

  var word = ""
  for item in commands.splitWhitespace():
    var n: int
    if item.parseInt(n) == 0:
      # Not a number.
      if word.len != 0:
        # No minimal length specified for the word.
        result[word] = word.len
      word = item
    else:
      # Got an integer.
      if word.len == 0:
        raise newException(ValueError, "Invalid position for number: " & $n)
      result[word] = n
      word = ""

#---------------------------------------------------------------------------------------------------

proc abbreviations(commandTable: Table[string, int]): Table[string, string] =
  ## For each command insert all possible abbreviations.
  for command, minlength in commandTable.pairs:
    for length in minLength..command.len:
      let abbr = command[0..<length].toLower
      result[abbr] = command.toUpper

#---------------------------------------------------------------------------------------------------

proc parse(words: seq[string]; abbrevTable: Table[string, string]): seq[string] =
  ## Parse a list of words and return the list of full words (or *error*).
  for word in words:
    result.add(abbrevTable.getOrDefault(word.toLower, "*error*"))

#---------------------------------------------------------------------------------------------------

let commandTable = Commands.abbrevationLengths()
let abbrevTable = commandTable.abbreviations()

while true:

  try:
    stdout.write "Input? "
    let userWords = stdin.readline().strip().splitWhitespace()
    let fullWords = userWords.parse(abbrevTable)
    stdout.write("\nUser words: ")
    for i, word in userWords:
      stdout.write(word.alignLeft(fullWords[i].len) & ' ')
    stdout.write("\nFull words: ")
    for word in fullWords:
      stdout.write(word & ' ')
    stdout.write("\n\n")

  except EOFError:
    echo ""
    break
