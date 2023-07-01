(de oddWords ()
   (use C
      (loop
         (until (sub? (prin (setq C (char))) "!,.:;?"))
         (T (= "." C))
         (setq C (char))
         (T
            (= "."
               (prin
                  (recur (C)
                     (if (sub? C "!,.:;?")
                        C
                        (prog1 (recurse (char)) (prin C)) ) ) ) ) ) )
   (prinl) ) )
