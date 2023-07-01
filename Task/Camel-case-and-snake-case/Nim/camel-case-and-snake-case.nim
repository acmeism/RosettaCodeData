import std/[strformat, strutils, unicode]

const Delimiters = [Rune('_'), Rune('-'), Rune(' ')]

func toCamelCase(s: string): string =
  let s = s.strip(chars = Whitespace)
  var prev = Rune(0)
  for rune in s.runes:
    if prev in Delimiters:
      result.add rune.toUpper
    elif rune notin Delimiters:
      result.add rune
    prev = rune

func toSnakeCase(s: string): string =
  var s= s.strip(chars = Whitespace).replace(' ', '_')
  var idx = 0
  var prev =  Rune(0)
  for rune in s.runes:
    if rune.isUpper and idx > 0:
      if prev notin Delimiters:
        result.add '_'
      result.add rune.toLower
    else:
      result.add rune
    prev = rune
    inc idx

const Strings = ["snakeCase", "snake_case", "variable_10_case",
                 "variable10Case", "ɛrgo rE tHis", "hurry-up-joe!",
                 "c://my-docs/happy_Flag-Day/12.doc", "  spaces  "]

echo center("### To snake case ###", 69)
for s in Strings:
  echo &"{s:>33} → {s.toSnakeCase}"

echo()
echo center("### To camel case ###", 69)
for s in Strings:
  echo &"{s:>33} → {s.toCamelCase}"
