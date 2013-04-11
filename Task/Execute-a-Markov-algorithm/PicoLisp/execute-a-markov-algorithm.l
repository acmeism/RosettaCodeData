(de markov (File Text)
   (use (@A @Z R)
      (let Rules
         (make
            (in File
               (while (skip "#")
                  (when (match '(@A " " "-" ">" " " @Z) (replace (line) "@" "#"))
                     (link (cons (clip @A) (clip @Z))) ) ) ) )
         (setq Text (chop Text))
         (pack
            (loop
               (NIL
                  (find
                     '((R) (match (append '(@A) (car R) '(@Z)) Text))
                     Rules )
                  Text )
               (T (= "." (cadr (setq R @)))
                  (append @A (cddr R) @Z) )
               (setq Text (append @A (cdr R) @Z)) ) ) ) ) )
