(de leftAssoc (Op)
   (member Op '("*" "/" "+" "-")) )

(de precedence (Op)
   (case Op
      ("\^" 4)
      (("*" "/") 3)
      (("+" "-") 2) ) )

(de rpnToInfix (Str)
   (let Stack NIL
      (prinl "Token  Stack")
      (for Token (str Str "_")
         (cond
            ((num? Token) (push 'Stack (cons 9 @)))  # Highest precedence
            ((not (cdr Stack)) (quit "Stack empty"))
            (T
               (let (X (pop 'Stack)  P (precedence Token))
                  (set Stack
                     (cons P
                        (pack
                           (if ((if (leftAssoc Token) < <=) (caar Stack) P)
                              (pack "(" (cdar Stack) ")")
                              (cdar Stack) )
                           " " Token " "
                           (if ((if (leftAssoc Token) <= <) (car X) P)
                              (pack "(" (cdr X) ")")
                              (cdr X) ) ) ) ) ) ) )
         (prin Token)
         (space 6)
         (println Stack) )
      (prog1 (cdr (pop 'Stack))
         (and Stack (quit "Garbage remained on stack")) ) ) )
