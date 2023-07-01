? def text := "Given$a$text$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column."; null

? println(alignColumns(left, text))
Given      a          text       file   of     many      lines,     where    fields  within  a      line
are        delineated by         a      single 'dollar'  character, write    a       program
that       aligns     each       column of     fields    by         ensuring that    words   in     each
column     are        separated  by     at     least     one        space.
Further,   allow      for        each   word   in        a          column   to      be      either left
justified, right      justified, or     center justified within     its      column.

? println(alignColumns(center, text))
   Given        a        text     file    of      many     lines,     where   fields  within    a   line
    are    delineated     by        a   single  'dollar' character,   write     a    program
   that      aligns      each    column   of     fields      by     ensuring   that   words    in   each
  column       are     separated   by     at     least       one     space.
 Further,     allow       for     each   word      in         a      column     to      be   either left
justified,    right   justified,   or   center justified   within      its   column.

? println(alignColumns(right, text))
      Given          a       text   file     of      many     lines,    where  fields  within      a line
        are delineated         by      a single  'dollar' character,    write       a program
       that     aligns       each column     of    fields         by ensuring    that   words     in each
     column        are  separated     by     at     least        one   space.
   Further,      allow        for   each   word        in          a   column      to      be either left
 justified,      right justified,     or center justified     within      its column.
