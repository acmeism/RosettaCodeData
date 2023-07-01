(de brackets (Lst)
   (let S NIL
      (make
         (for (I . X) Lst
            (case X
               ("[" (push 'S I))
               ("]"
                  (unless S (quit "Unbalanced '['"))
                  (link (list (pop 'S) I)) ) ) )
         (when S (quit "Unbalanced ']'")) ) ) )

(de lupbra (Lst N)
   (find
      '((I)
         (or
            (= (car I) N)
            (= (cadr I) N) ) )
      Lst ) )

(de brain (L)
   (let
      (D (0)
         DH 1
         DL 1
         CH 1
         CL (length L)
         B (brackets L) )
      (loop
         (case (get L CH)
            (>
               (inc 'DH)
               (when (> DH DL)
                  (setq D (insert DH D 0))
                  (inc 'DL) ) )
            (<
               (dec 'DH)
               (when (< DH 1)
                  (setq D (insert DH D 0))
                  (inc 'DL)
                  (one DH) ) )
            (+ (inc (nth D DH)))
            (- (dec (nth D DH)))
            (. (prin (char (get D DH))))
            ("," (set (nth D DH) (char (key))))
            ("["
               (when (=0 (get D DH))
                  (setq CH (cadr (lupbra B CH))) ) )
            ("]"
               (when (n0 (get D DH))
                  (setq CH (car (lupbra B CH))) ) ) )
         (inc 'CH)
         (T (> CH CL)) ) ) )

(brain (chop ">+++++++++[<++++++++>-]<.>+++++++[<++++>-]<+.+++++++..+++.[-]
>++++++++[<++++>-] <.>+++++++++++[<++++++++>-]<-.--------.+++.------.---
-----.[-]>++++++++[<++++>- ]<+.[-]++++++++++." ) )

(bye)
