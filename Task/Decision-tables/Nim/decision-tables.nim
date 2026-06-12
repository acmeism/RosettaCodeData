import strutils, tables

####################################################################################################
# Generic defintion of the decision table.

type

  DTable[Cond, Act: Ordinal] = object
    questions: array[Cond, string]
    answers: array[Act, string]
    rules: Table[set[Cond], seq[Act]]

proc initDTable[Cond, Act](): DTable[Cond, Act] = discard

proc addCondition[Cond, Act](dt: var DTable[Cond, Act]; cond: Cond; question: string) =
  if dt.questions[cond].len != 0:
    raise newException(ValueError, "condition already set: " & $cond)
  dt.questions[cond] = question

proc addAction[Cond, Act](dt: var DTable[Cond, Act]; act: Act; answer: string) =
  if dt.answers[act].len != 0:
    raise newException(ValueError, "action already set: " & $act)
  dt.answers[act] = answer

proc addRule[Cond, Act](dt: var DTable[Cond, Act]; rule: set[Cond]; acts: openArray[Act]) =
  if rule in dt.rules:
    raise newException(ValueError, "rule already set.")
  dt.rules[rule] = @acts

proc askQuestion(question: string): string =
  while true:
    stdout.write question & ' '
    stdout.flushFile()
    result = stdin.readLine().strip()
    if result in ["y", "n"]: break


proc apply[Cond, Act](dt: DTable[Cond, Act]) =

  # Build condition set.
  var conds: set[Cond]
  echo "Answer questions with 'y' or 'n'"
  for cond, question in dt.questions:
    if question.len == 0:
      raise newException(ValueError, "missing question for condition: " & $cond)
    let answer = askQuestion(question)
    if answer == "y":
      conds.incl cond

  # Apply rule.
  echo()
  if conds in dt.rules:
    echo "Actions recommended:"
    for act in dt.rules[conds]:
      echo "- ", dt.answers[act]
  else:
    echo "No action recommended."


####################################################################################################
# Decision table for Wikipedia printer example.

type

  Condition {.pure.} = enum PrinterPrints, RedLightFlashing, PrinterRecognized
  Action {.pure.} = enum CheckPowerCable, CheckPrinterCable, CheckSoftware, CheckInk, CheckPaperJam

const

  Questions = [PrinterPrints:     "Does printer print?",
               RedLightFlashing:  "Does red light is flashing?",
               PrinterRecognized: "Is printer recognized by computer?"]

  Answers = [CheckPowerCable:   "check the power cable",
             CheckPrinterCable: "check the printer-computer cable",
             CheckSoftware:     "ensure printer software is installed",
             CheckInk:          "check/replace ink",
             CheckPaperJam:     "check for paper jam"]

var dt = initDTable[Condition, Action]()

for cond, question in Questions:
  dt.addCondition(cond, question)

for act, answer in Answers:
  dt.addAction(act, answer)

dt.addRule({}, [CheckPowerCable, CheckPrinterCable, CheckSoftware])
dt.addRule({PrinterPrints}, [CheckSoftware])
dt.addRule({RedLightFlashing}, [CheckPrinterCable, CheckSoftware, CheckInk])
dt.addRule({PrinterRecognized}, [CheckPaperJam])
dt.addRule({PrinterPrints, RedLightFlashing}, [CheckSoftware])
dt.addRule({RedLightFlashing, PrinterRecognized}, [CheckInk, CheckPaperJam])
dt.addRule({PrinterPrints, RedLightFlashing, PrinterRecognized}, [CheckInk])

dt.apply()
