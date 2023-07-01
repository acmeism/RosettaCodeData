(de n! (N)
       (cache '(NIL) N
          (if (> 2 N) 1
	      (* N (n! (dec N))))))

(de !n (Num)
  (if (= Num 0) 1
      (sum n! (range 0 (dec Num)))))

(de pril (List) (mapcar 'println List))

(prinl "0-10")
(pril (mapcar '!n (range 0 10)))
(prinl "20 - 110")
(pril (mapcar '!n (range 20 110 10)))
(prinl "length of 1000 - 10000")
(pril (mapcar 'length (mapcar '!n (range 1000 10000 1000))))
