(off "Program")

(de compile (File)
   (let Stack NIL
      (setq "Program"
         (make
            (in File
               (while (char)
                  (case @
                     (">"
                        (link
                           '(setq Data
                              (or
                                 (cddr Data)
                                 (con (cdr Data) (cons 0 (cons Data))) ) ) ) )
                     ("<"
                        (link
                           '(setq Data
                              (or
                                 (cadr Data)
                                 (set (cdr Data) (cons 0 (cons NIL Data))) ) ) ) )
                     ("+" (link '(inc Data)))
                     ("-" (link '(dec Data)))
                     ("." (link '(prin (char (car Data)))))
                     ("," (link '(set Data (char (read)))))
                     ("["
                        (link
                           '(setq Code
                              ((if (=0 (car Data)) cdar cdr) Code) ) )
                        (push 'Stack (chain (cons))) )
                     ("]"
                        (unless Stack
                           (quit "Unbalanced ']'") )
                        (link
                           '(setq Code
                              ((if (n0 (car Data)) cdar cdr) Code) ) )
                        (let (There (pop 'Stack)  Here (cons There))
                           (chain (set There Here)) ) ) ) ) ) ) )
      (when Stack
         (quit "Unbalanced '['") ) ) )

(de execute ()
   (let Data (cons 0 (cons))              # Create initial cell
      (for (Code "Program"  Code)         # Run program
         (eval (pop 'Code)) )
      (while (cadr Data)                  # Find beginning of data
         (setq Data @) )
      (filter prog Data '(T NIL .)) ) )   # Return data space
