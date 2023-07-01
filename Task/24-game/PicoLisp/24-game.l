(load "@lib/frac.l")

(de random4digits ()
   (setq Numbers (make (do 4 (link (rand 1 9)))))
   Numbers )

(de prompt ()
   (prinl
      "^JPlease enter a 'Lisp' expression (integer or fractional math) that equals 24,^J"
      "using (, ), frac, + or f+, - or f-, * or f*, / or f/, and " Numbers "^J"
      "(use each number only once). Enter . to quit." ) )

(de getinput ()
   (setq Expression (catch ’NIL (in NIL (read))))
   Expression )

(de checkexpression (Numbers Expression)
   (make
      (when (diff Numbers (fish num? Expression))
         (link "Not all numbers used.") )
      (when (diff (fish num? Expression) Numbers)
         (link "Using wrong number(s)."))
      (if (sub? "f" (pack Expression))
         (when (diff (fish sym? Expression) '(frac f+ f- f* f/))
            (link "Illegal operator(s). If fractional expression, must use frac, f+, f-, f*, f/ only.") )
         (when (diff (fish sym? Expression) '(+ - * /))
            (link "Using illegal operator(s).") ) ) ) )

(de instructions ()
   (prinl "Example 'Lisp' expression: (- (* 3 9) (+ 1 2))")
   (prinl
      "Example 'Lisp' fractional expression:^J"
      "(f- (f* (frac 3 1)(frac 9 1)) (f+ (frac 1 1)(frac 2 1)))" )
   (prinl
      "Use a fractional expression 'just for fun (as above)' OR if your solution^J"
      "would lose remainder value(s) otherwise (through integer division)." ) )

(de loopuntilquit ()
   (instructions)
   (loop
      (set 'Numbers (random4digits))
      (prompt)
      (set 'Expression (getinput))
      (if (= Expression ".") (prog (prinl "bye!") (bye)))
      (set 'Check (checkexpression Numbers Expression))
      (if (car Check)
         (mapcar prinl Check)
         (prog
            (set 'Evaluated (eval Expression))
            (if (or (= Evaluated 24) (= Evaluated (24 . 1)))
               (prinl "Congratulations!")
               (prinl "That evaluated to " Evaluated " Try again!") ) ) ) ) )

(loopuntilquit)
