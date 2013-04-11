(de pokemonChain (File)
   (let Names (make (in File (while (read) (link @))))
      (for Name Names
         (let C (last (chop Name))
            (set Name
               (filter '((Nm) (pre? C Nm)) Names) ) ) )
      (let Res NIL
         (for Name Names
            (let Lst NIL
               (recur (Name Lst)
                  (if (or (memq Name Lst) (not (val (push 'Lst Name))))
                     (when (> (length Lst) (length Res))
                        (setq Res Lst) )
                     (mapc recurse (val Name) (circ Lst)) ) ) ) )
         (flip Res) ) ) )
