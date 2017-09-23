from strutils import splitLines, split
from sequtils import mapIt
from strfmt import format, write

let textinfile = """Given$a$text$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column."""

var words = textinfile.splitLines.mapIt(it.split '$')
var maxs = newSeq[int](max words.mapIt(it.len))

for line in words:
  for j,w in line:
    maxs[j] = max(maxs[j], w.len+1)

for i, align in ["<",">","^"]:
  echo(["Left", "Right", "Center"][i], " column-aligned output:")
  for line in words:
    for j,w in line:
      stdout.write(w.format align & $maxs[j])
    stdout.write "\n"
  stdout.write "\n"
