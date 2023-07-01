(defn flatten [lst]
  (sum (genexpr (if (isinstance x list)
                    (flatten x)
                    [x])
                [x lst])
       []))

(print (flatten [[1] 2 [[3 4] 5] [[[]]] [[[6]]] 7 8 []]))
; [1, 2, 3, 4, 5, 6, 7, 8]
