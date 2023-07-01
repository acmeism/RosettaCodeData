import rdstdin, re, algorithm, sequtils, strutils

#let templ = readLineFromStdin "Enter your story: "
const templ = """<name> went for a walk in the park. <he or she>
found a <noun>. <name> decided to take it home."""

echo "The story template is:\n", templ
var fields = templ.findAll re"<[^>]+>"
fields.sort(cmp)
fields = deduplicate fields
let values = readLineFromStdin("\nInput a comma-separated list of words to replace the following items\n  " & fields.join(",") & ": ").split(",")

var story = templ
for f,v in zip(fields, values).items:
  story = story.replace(f, v)
echo "\nThe story becomes:\n\n", story
