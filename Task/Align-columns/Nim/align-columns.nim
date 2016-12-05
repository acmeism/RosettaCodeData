import strutils, sequtils, strfmt

let textinfile = """Given$a$text$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column."""

var words = textinfile.splitLines.mapIt(seq[string], it.split '$')
var maxs = newSeq[int](max words.mapIt(int, it.len))

for l in words:
  for j,w in l:
    maxs[j] = max(maxs[j], w.len+1)

for i, align in ["<",">","^"]:
  echo(["Left", "Right", "Center"][i], " column-aligned output:")
  for l in words:
    for j,w in l:
      stdout.write w.format align & $maxs[j]
    stdout.write "\n"
