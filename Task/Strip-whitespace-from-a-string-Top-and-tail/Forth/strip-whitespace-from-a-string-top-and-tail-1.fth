: -leading ( addr len -- addr' len' ) \ called "minus-leading"
    begin
      over c@ bl =  \ fetch character at addr, test if blank (space)
    while
     \ cut 1 leading character by incrementing address & decrementing length
      1 /string      \ "cut-string"
   repeat ;
