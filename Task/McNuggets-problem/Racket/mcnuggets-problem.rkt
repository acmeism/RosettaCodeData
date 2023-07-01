#lang racket
(apply max (set->list (for*/fold ((s (list->set (range 1 101))))
                                 ((x (in-range 0 101 20))
                                  (y (in-range x 101 9))
                                  (n (in-range y 101 6)))
                        (set-remove s n))))
