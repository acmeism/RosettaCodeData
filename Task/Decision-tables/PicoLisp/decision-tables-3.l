(de decide ()
   (let Reply (mapcar yes? *Conditions)
      (extract and
         (apply pick (append *Conditions *Actions)
            '(@
               (unless (pick '((Flg) (<> Flg (next))) Reply)
                  (rest) ) ) )
         (mapcar car *Actions) ) ) )
