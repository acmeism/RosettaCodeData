text = .array~of("Given$a$text$file$of$many$lines,$where$fields$within$a$line$", -
                 "are$delineated$by$a$single$'dollar'$character,$write$a$program", -
                 "that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$", -
                 "column$are$separated$by$at$least$one$space.", -
                 "Further,$allow$for$each$word$in$a$column$to$be$either$left$", -
                 "justified,$right$justified,$or$center$justified$within$its$column.")

columns = 0
parsedText = .array~new
-- split each line of text into words and figure out how many columns we need
loop line over text
    parsedLine = line~makearray("$")
    parsedText~append(parsedLine)
    columns = max(columns, parsedLine~items)
end

-- now figure out how wide we need to make each column
columnWidths = .array~new(columns)
linelength = 0
loop i = 1 to columns
    width = 0
    loop line over parsedText
        word = line[i]
        if word \= .nil then width = max(width, word~length)
    end
    columnWidths[i] = width
    -- keep track of the total width, including space for a separator
    linelength += width + 1
end

say "align left:"
say
out = .mutableBuffer~new(linelength)
loop line over parsedText
  -- mutable buffers are more efficient than repeated string concats
  -- reset the working buffer to zero
  out~setbuffersize(0)
  loop col = 1 to line~items
      word = line[col]
      if word == .nil then word = ''
      out~append(word~left(columnwidths[col] + 1))
  end
  say out~string
end
say
say "align right:"
say

loop line over parsedText
  -- mutable buffers are more efficient than repeated string concats
  -- reset the working buffer to zero
  out~setbuffersize(0)
  loop col = 1 to line~items
      word = line[col]
      if word == .nil then word = ''
      out~append(word~right(columnwidths[col] + 1))
  end
  say out~string
end
say
say "align center:"
say

loop line over parsedText
  -- mutable buffers are more efficient than repeated string concats
  -- reset the working buffer to zero
  out~setbuffersize(0)
  loop col = 1 to line~items
      word = line[col]
      if word == .nil then word = ''
      out~append(word~center(columnwidths[col] + 1))
  end
  say out~string
end
