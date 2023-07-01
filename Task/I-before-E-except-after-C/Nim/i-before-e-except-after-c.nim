import httpclient, strutils, strformat

const
  Rule1 = "\"I before E when not preceded by C\""
  Rule2 = "\"E before I when preceded by C\""
  Phrase = "\"I before E except after C\""
  PlausibilityText: array[bool, string] = ["not plausible", "plausible"]


proc plausibility(rule: string; count1, count2: int): bool =
  ## Compute, display and return plausibility.
  result = count1 > 2 * count2
  stdout.write &"The rule {rule} is {PlausibilityText[result]}: "
  echo &"there were {count1} examples and {count2} counter-examples."


let client = newHttpClient()

var nie, cie, nei, cei = 0
for word in client.getContent("http://wiki.puzzlers.org/pub/wordlists/unixdict.txt").split():
  if word.contains("ie"):
    if word.contains("cie"):
      inc cie
    else:
      inc nie
  if word.contains("ei"):
    if word.contains("cei"):
      inc cei
    else:
      inc nei

let p1 = plausibility(Rule1, nie, nei)
let p2 = plausibility(Rule2, cei, cie)
echo &"So the phrase {Phrase} is {PlausibilityText[p1 and p2]}."
