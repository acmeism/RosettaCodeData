pad = (n) ->
  s = ''
  while n > 0
    s += ' '
    n -= 1
  s

align = (input, alignment = 'center') ->
  tokenized_lines = (line.split '$' for line in input)
  col_widths = {}
  for line in tokenized_lines
    for token, i in line
      if !col_widths[i]? or token.length > col_widths[i]
        col_widths[i] = token.length
  padders =
    center: (s, width) ->
      excess = width - s.length
      left = Math.floor excess / 2
      right = excess - left
      pad(left) + s + pad(right)

    right: (s, width) ->
      excess = width - s.length
      pad(excess) + s

    left: (s, width) ->
      excess = width - s.length
      s + pad(excess)

  padder = padders[alignment]

  for line in tokenized_lines
    padded_tokens = (padder(token, col_widths[i]) for token, i in line)
    console.log padded_tokens.join ' '


input = [
  "Given$a$text$file$of$many$lines,$where$fields$within$a$line$"
  "are$delineated$by$a$single$'dollar'$character,$write$a$program"
  "that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$"
  "column$are$separated$by$at$least$one$space."
  "Further,$allow$for$each$word$in$a$column$to$be$either$left$"
  "justified,$right$justified,$or$center$justified$within$its$column."
]

for alignment in ['center', 'right', 'left']
  console.log "\n----- #{alignment}"
  align input, alignment
