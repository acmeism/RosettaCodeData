(let (Pat "a[0-9]z"  String "a7z")
   (use Preg
      (native "@" "regcomp" 'I '(Preg (64 B . 64)) Pat 1)  # Compile regex
      (when (=0 (native "@" "regexec" 'I (cons NIL (64) Preg) String 0 0 0))
         (prinl "String \"" String "\" matches regex \"" Pat "\"") ) ) )
