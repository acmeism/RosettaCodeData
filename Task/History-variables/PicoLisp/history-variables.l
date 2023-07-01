(de setH ("Var" Val)
   (when (val "Var")
      (with "Var"
         (=: history (cons @ (: history))) ) )
   (set "Var" Val) )

(de restoreH ("Var")
   (set "Var" (pop (prop "Var" 'history))) )
