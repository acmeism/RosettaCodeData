       identification division.
       program-id. BUBBLSRT.
       data division.
       working-storage section.
       01 changed-flag      pic x.
          88 hasChanged         value 'Y'.
          88 hasNOTChanged      value 'N'.
       01 itemCount         pic 99.
       01 tempItem          pic 99.
       01 itemArray.
          03 itemArrayCount pic 99.
          03 item           pic 99 occurs 99 times
                                   indexed by itemIndex.
      *
       procedure division.
       main.
      * place the values to sort into itemArray
           move 10 to itemArrayCount
           move 28 to item (1)
           move 44 to item (2)
           move 46 to item (3)
           move 24 to item (4)
           move 19 to item (5)
           move  2 to item (6)
           move 17 to item (7)
           move 11 to item (8)
           move 24 to item (9)
           move  4 to item (10)
      * store the starting count in itemCount and perform the sort
           move itemArrayCount to itemCount
           perform bubble-sort
      * output the results
           perform varying itemIndex from 1 by 1
              until itemIndex > itemArrayCount
              display item (itemIndex) ';' with no advancing
           end-perform
      * thats it!
           stop run.
      *
       bubble-sort.
           perform with test after until hasNOTchanged
              set hasNOTChanged to true
              subtract 1 from itemCount
              perform varying itemIndex from 1 by 1
                 until itemIndex > itemCount
                 if item (itemIndex) > item (itemIndex + 1)
                    move item (itemIndex) to tempItem
                    move item (itemIndex + 1) to item (itemIndex)
                    move tempItem to item (itemIndex + 1)
                    set hasChanged to true
                 end-if
              end-perform
           end-perform
           .
