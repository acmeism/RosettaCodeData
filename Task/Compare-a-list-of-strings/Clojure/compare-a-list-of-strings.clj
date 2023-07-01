;; Checks if all items in strings list are equal (returns true if list is empty)
(every?	(fn [[a nexta]] (= a nexta)) (map vector strings (rest strings))))

;; Checks strings list is in ascending order (returns true if list is empty)
(every?	(fn [[a nexta]] (<= (compare a nexta) 0)) (map vector strings (rest strings))))
