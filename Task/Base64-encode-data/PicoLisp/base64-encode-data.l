`(== 64 64)
(setq *Char64
   `'(chop
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/" ) )
(de char64 (A B)
   (default B 0)
   (get *Char64 (inc (| A B))) )
(de base64 (S)
   (let S (mapcar char (chop S))
      (pack
         (make
            (while (cut 3 'S)
               (let ((A B C) @)
                  (link (char64 (>> 2 A)))
                  (nond
                     (B
                        (link
                           (char64 (>> -4 (& A 3)))
                           '=
                           '= ) )
                     (C
                        (link
                           (char64 (>> -4 (& A 3)) (>> 4 B))
                           (char64 (>> -2 (& B 15)))
                           '= ) )
                     (NIL
                        (link
                           (char64 (>> -4 (& A 3)) (>> 4 B))
                           (char64 (>> -2 (& B 15)) (>> 6 C))
                           (char64 (& C 63))) ) ) ) ) ) ) ) )
(test
   "cGxlYXN1cmUu"
   (base64 "pleasure.") )
(test
   "bGVhc3VyZS4="
   (base64 "leasure.") )
(test
   "ZWFzdXJlLg=="
   (base64 "easure.") )
(test
   "YXN1cmUu"
   (base64 "asure.") )
(test
   "c3VyZS4="
   (base64 "sure.") )
