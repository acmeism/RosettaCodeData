(import (scheme char))

(define (comp a b)
   (let ((la (string-length a))
         (lb (string-length b)))
      (or
         (> la lb)
         (and (= la lb) (string-ci<? a b)))))

(print
   (sort comp '(
      "lorem" "ipsum" "dolor" "sit" "amet" "consectetur"
      "adipiscing" "elit" "maecenas" "varius" "sapien"
      "vel" "purus" "hendrerit" "vehicula" "integer"
      "hendrerit" "viverra" "turpis" "ac" "sagittis"
      "arcu" "pharetra" "id")))
