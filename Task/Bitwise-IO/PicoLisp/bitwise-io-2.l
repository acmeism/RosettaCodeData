(out 'a (write7bitwise (127 0 127 0 127 0 127 0 127)))
(hd 'a)
(in 'a (println (read7bitwise)))

(out 'a (write7bitwise (0 127 0 127 0 127 0 127 0)))
(hd 'a)
(in 'a (println (read7bitwise)))

(out 'a (write7bitwise (mapcar char (chop "STRING"))))
(hd 'a)
(println (mapcar char (in 'a (read7bitwise))))
