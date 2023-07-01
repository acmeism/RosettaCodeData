(de operator (Op)
   (member Op '("\^" "*" "/" "+" "-")) )

(de leftAssoc (Op)
   (member Op '("*" "/" "+" "-")) )

(de precedence (Op)
   (case Op
      ("\^" 4)
      (("*" "/") 3)
      (("+" "-") 2) ) )

(de shuntingYard (Str)
   (make
      (let (Fmt (-7 -30 -4)  Stack)
         (tab Fmt "Token" "Output" "Stack")
         (for Token (str Str "_")
            (cond
               ((num? Token) (link @))
               ((= "(" Token) (push 'Stack Token))
               ((= ")" Token)
                  (until (= "(" (car Stack))
                     (unless Stack
                        (quit "Unbalanced Stack") )
                     (link (pop 'Stack)) )
                  (pop 'Stack) )
               (T
                  (while
                     (and
                        (operator (car Stack))
                        ((if (leftAssoc (car Stack)) <= <)
                           (precedence Token)
                           (precedence (car Stack)) ) )
                     (link (pop 'Stack)) )
                  (push 'Stack Token) ) )
            (tab Fmt Token (glue " " (made)) Stack) )
         (while Stack
            (when (= "(" (car Stack))
               (quit "Unbalanced Stack") )
            (link (pop 'Stack))
            (tab Fmt NIL (glue " " (made)) Stack) ) ) ) )
