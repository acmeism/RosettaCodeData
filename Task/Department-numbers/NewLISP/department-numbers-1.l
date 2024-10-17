(and
  (println "--police--  --sanitation--  --fire--")
  (dolist (lst
    (filter
      (fn(l) (and (= (unique l) l)
                  (= 12 (apply + l))
                  (member (l 0) '(2 4 6))
                  (= 2 (length (intersect (rest l)
                                          '(1 2 3 4 5 6 7))))))
      (map (fn(n) (map int (explode (string n))))
           (sequence 111 777))))
    (println (format  "    %d             %d            %d"
               lst))))
