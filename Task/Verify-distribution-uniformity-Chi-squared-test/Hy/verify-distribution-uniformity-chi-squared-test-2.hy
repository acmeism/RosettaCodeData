(import [random [randint]])

(for [f [
    (fn [] (randint 1 10))
    (fn [] (if (randint 0 1) (randint 1 9) (randint 1 10)))]]
  (print (uniform? f 5000)))
