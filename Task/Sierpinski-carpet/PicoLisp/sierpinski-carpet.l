(de carpet (N)
   (let Carpet '("#")
      (do N
         (setq Carpet
            (conc
               (mapcar '((S) (pack S S S)) Carpet)
               (mapcar
                  '((S) (pack S (replace (chop S) "#" " ") S))
                  Carpet )
               (mapcar '((S) (pack S S S)) Carpet) ) ) ) ) )

(mapc prinl (carpet 3))
