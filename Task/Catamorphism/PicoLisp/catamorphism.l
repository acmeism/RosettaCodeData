(de reduce ("Fun" "Lst")
   (let "A" (car "Lst")
      (for "N" (cdr "Lst")
         (setq "A" ("Fun" "A" "N")) )
      "A" ) )

(println
   (reduce + (1 2 3 4 5))
   (reduce * (1 2 3 4 5)) )

(bye)
