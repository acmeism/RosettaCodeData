(let Buf NIL
   (in NIL
      (until (eof)
         (let (Line (line)  Len (length Line))
            (if (assoc Len Buf)
               (conc @ (cons Line))
               (push 'Buf (cons Len (cons Line))) ) ) ) )
   (mapc prinl (cdr (maxi car Buf))) )
