printAll=: {{
   while. more y do.
     echo value y
     y=.  iterate y
  end.EMPTY
}}
   DOW=:  nextItem`{::`# makeIterator ;:'monday tuesday wednesday thursday friday saturday sunday'
   COL=:  nextLink`{::`# makeIterator (,<)/;:'red orange yellow green blue purple'

    printAll DOW
monday
tuesday
wednesday
thursday
friday
saturday
sunday
   printAll COL
red
orange
yellow
green
blue
purple
   value iterate^:0 DOW
monday
   value iterate^:3 DOW
thursday
