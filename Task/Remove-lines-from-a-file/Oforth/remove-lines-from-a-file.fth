: removeLines(filename, startLine, numLines)
| line b endLine |
   ListBuffer new ->b
   startLine numLines + 1 - ->endLine

   0 File new(filename) forEach: line [
      1+ dup between(startLine, endLine) ifFalse: [ b add(line) continue ]
      numLines 1- ->numLines
      ]
   drop numLines 0 == ifFalse: [ "Error : Removing lines beyond end of file" println return ]

   File new(filename) dup open(File.WRITE) b apply(#[ << dup cr ]) close ;
