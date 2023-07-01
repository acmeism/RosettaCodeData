(defmacro branch-if-macro
  [branch-if Cond1 Cond2 Both Fst Snd None] ->
    [if Cond1
        [if Cond2 Both Fst]
        [if Cond2 Snd None]])
