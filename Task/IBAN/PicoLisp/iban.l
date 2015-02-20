(setq *Sizes '((GB . 22) (CH . 21) (SA . 24)))

(de iban (Str)
   (let Lst
      (filter
         '((X) (not (sp? X)))
         (chop (uppc Str)) )
      (when
         (=
            (cdr (assoc (pack (head 2 Lst)) *Sizes))
            (length Lst) )
         (%
            (format
               (mapcar
                  '((X)
                     (if (upp? X)
                        (- (char X) 55)
                        X ) )
                  (append (nth Lst 5) (head 4 Lst)) ) )
            97 ) ) ) )

(for I '("sa03 8000 0000 6080 1016 7519"
         "CH9300762011623852957"
         "gb82west1234 56987654 32"
         "GB82WEST000")
   (if (= 1 (iban I))
      (println 'Valid)
      (println 'Invalid) ) )

(bye)
