       identification division.
       program-id. AlignColumns.

       data division.
       working-storage section.
      *>-> Constants
       78 MAX-LINES value 6.
       78 MAX-LINE-SIZE value 66.
       78 MAX-COLUMNS value 12.
       78 MAX-COLUMN-SIZE value 16.
      *>-> Indexes
       01 w-idx                   pic is 9(2).
       01 w-idy                   pic is 9(2).
       01 w-pos                   pic is 9(3).
      *>-> Data structures
       01 w-lines.
          05 w-line               pic is x(MAX-LINE-SIZE) occurs MAX-LINES.
       01 w-column-sizes.
          05 w-column-size        pic is 99 occurs MAX-COLUMNS value zeros.
       01 w-matrix.
          05 filler               occurs MAX-LINES.
             10 filler            occurs MAX-COLUMNS.
                15 w-content      pic is x(MAX-COLUMN-SIZE).
      *>-> Output
       01 w-line-out              pic is x(120).
      *>-> Data alignment
       01 w-alignment             pic is x(1).
          88 alignment-left       value is "L".
          88 alignment-center     value is "C".
          88 alignment-right      value is "R".

       procedure division.
       main.
           move "Given$a$text$file$of$many$lines,$where$fields$within$a$line$" to w-line(1)
           move "are$delineated$by$a$single$'dollar'$character,$write$a$program" to w-line(2)
           move "that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$" to w-line(3)
           move "column$are$separated$by$at$least$one$space." to w-line(4)
           move "Further,$allow$for$each$word$in$a$column$to$be$either$left$" to w-line(5)
           move "justified,$right$justified,$or$center$justified$within$its$column." to w-line(6)
           perform calculate-size-columns
           set alignment-left to true
           perform show-content
           set alignment-center to true
           perform show-content
           set alignment-right to true
           perform show-content
           goback
           .
       calculate-size-columns.
           perform
              varying             w-idx from 1 by 1
                 until            w-idx > MAX-LINES
              unstring w-line(w-idx) delimited by "$" into w-content(w-idx, 1), w-content(w-idx, 2),
                  w-content(w-idx, 3), w-content(w-idx, 4), w-content(w-idx, 5), w-content(w-idx, 6),
                  w-content(w-idx, 7), w-content(w-idx, 8), w-content(w-idx, 9), w-content(w-idx, 10),
                  w-content(w-idx, 11), w-content(w-idx, 12),
              perform
                 varying          w-idy from 1 by 1
                    until         w-idy > MAX-COLUMNS
                 if function stored-char-length(w-content(w-idx, w-idy)) > w-column-size(w-idy)
                    move function stored-char-length(w-content(w-idx, w-idy)) to w-column-size(w-idy)
                 end-if
              end-perform
           end-perform
           .
       show-content.
           move all "-" to w-line-out
           display w-line-out
           perform
              varying             w-idx from 1 by 1
                 until            w-idx > MAX-LINES
              move spaces to w-line-out
              move 1 to w-pos
              perform
                 varying          w-idy from 1 by 1
                    until         w-idy > MAX-COLUMNS
                 call "C$JUSTIFY" using w-content(w-idx, w-idy)(1:w-column-size(w-idy)), w-alignment
                 move w-content(w-idx, w-idy) to w-line-out(w-pos:w-column-size(w-idy))
                 compute w-pos = w-pos + w-column-size(w-idy) + 1
              end-perform
              display w-line-out
           end-perform
           .
