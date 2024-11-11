:class TextView' super{ TextView }
:m put: ( addr len -- )
   0 #ofChars: self SetSelect: self
   insert: self ;m
;class

Window+ w
  View wview
Button b
  100 30 100 20 setFrame: b
TextView' t
  200 30 200 15 setFrame: t

\ the running count is always on the stack
\ so a variable for that is not needed
:noname ( count -- count+1 )
  1+  \ increment the count
  " Number of clicks: " put: t
  dup deciNumstr insert: t ; setAction: b \ update the text representation of count

: go
   b addview: wview
   t addview: wview
  300 30 430 230 put: frameRect
    frameRect " Test" docWindow
    wview new: w  show: w
  " click me" setTitle: b
  " There have been no clicks yet" put: t
  0 ; \ the number of clicks start at zero

go
