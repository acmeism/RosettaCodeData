(let Path (in '(realpath "foo") (line T))
   (call 'mv Path (pack Path ".backup"))
   (out Path
      (prinl "This is the new file") ) )
