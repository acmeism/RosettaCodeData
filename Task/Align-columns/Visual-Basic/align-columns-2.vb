Sub Main() 'usage of the above
Const Text$ = "Given$a$text$file$of$many$lines,$where$fields$within$a$line$" & vbLf & _
              "are$delineated$by$a$single$'dollar'$character,$write$a$program" & vbLf & _
              "that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$" & vbLf & _
              "column$are$separated$by$at$least$one$space." & vbLf & _
              "Further,$allow$for$each$word$in$a$column$to$be$either$left$" & vbLf & _
              "justified,$right$justified,$or$center$justified$within$its$column."

  Debug.Print vbLf; "-- Left:":   AlignCols Split(Text, vbLf), vbLeftJustify
  Debug.Print vbLf; "-- Center:": AlignCols Split(Text, vbLf), vbCenter
  Debug.Print vbLf; "-- Right:":  AlignCols Split(Text, vbLf), vbRightJustify
End Sub
