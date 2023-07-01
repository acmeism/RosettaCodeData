import sequtils
import strutils

const Commands = "Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy " &
                 "COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find " &
                 "NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput " &
                 "Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO " &
                 "MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT " &
                 "READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT " &
                 "RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up"

#---------------------------------------------------------------------------------------------------

proc validate(words, commands: seq[string]; minLens: seq[int]): seq[string] =

  if words.len == 0:
    return

  for word in words:
    var matchFound = false
    for i, command in commands:
      if word.len notin minLens[i]..command.len:
        continue
      if command.toUpper.startsWith(word.toUpper):
        result.add(command.toUpper)
        matchFound = true
        break
    if not matchFound:
      result.add("*error*")

#---------------------------------------------------------------------------------------------------

var commands = Commands.splitWhitespace()
var minLens = newSeq[int](commands.len)     # Count of uppercase characters.
for idx, command in commands:
  minLens[idx] = command.countIt(it.isUpperAscii)

while true:

  try:
    stdout.write "Input? "
    let words = stdin.readline().strip().splitWhitespace()
    let results = words.validate(commands, minLens)
    stdout.write("\nUser words: ")
    for i, word in words:
      stdout.write(word.alignLeft(results[i].len) & ' ')
    stdout.write("\nFull words: ")
    for result in results:
      stdout.write(result & ' ')
    stdout.write("\n\n")

  except EOFError:
    echo ""
    break
