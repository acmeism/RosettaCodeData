(def plus-a-hundred (partial + 100))
(assert (=
           (plus-a-hundred 1)
           101))
