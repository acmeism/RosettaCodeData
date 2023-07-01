(de mdr-mp (N)
   "Returns the solutions in a list, i.e., '(MDR MP)"
   (let MP 0
      (while (< 1 (length N))
         (setq N (apply * (mapcar format (chop N))))
         (inc 'MP) )
      (list N MP) ) )



# Get the MDR/MP of these nums.
(setq Test-nums '(123321 7739 893 899998))

(let Fmt (6 5 5)
   (tab Fmt "Values" "MDR" "MP")
   (tab Fmt "======" "===" "==")
   (for I Test-nums
      (let MDR-MP (mdr-mp I)
         (tab Fmt I (car MDR-MP) (cadr MDR-MP)) ) ) )

(prinl)

# Get the nums of these MDRs.
(setq *Want 5)

(setq *Solutions (make (for MDR (range 0 9)
   (link (make (let N 0 (until (= *Want (length (made)))
      (when (= MDR (car (mdr-mp N)))
         (link N) )
      (inc 'N) )))) )))

(let Fmt (3 1 -1)
   (tab Fmt "MDR" ":  " "Values")
   (tab Fmt "===" "   " "======")
   (for (I . S) *Solutions
      (tab Fmt (dec I) ":  " (glue ", " S)) ) )
