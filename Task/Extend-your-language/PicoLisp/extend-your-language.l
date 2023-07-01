(undef 'if2)  # Undefine the built-in 'if2'

(de if2 "P"
   (if (eval (pop '"P"))
      (eval ((if (eval (car "P")) cadr caddr) "P"))
      (if (eval (car "P"))
         (eval (cadddr "P"))
         (run (cddddr "P")) ) ) )
