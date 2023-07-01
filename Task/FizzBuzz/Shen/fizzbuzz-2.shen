(defprolog fizz
  0 <-- (is _ (output "Fizz"));
  N <-- (when (> N 0)) (is N1 (- N 3)) (fizz N1);
)

(defprolog buzz
  0 <-- (is _ (output "Buzz"));
  N <-- (when (> N 0)) (is N1 (- N 5)) (buzz N1);
)

(define none
  [] -> true
  [true | _] -> false
  [_ | B] -> (none B)
)

(define fizzbuzz
  N M -> (nl) where (> N M)
  N M -> (do
    (if (none [(prolog? (receive N) (fizz N)) (prolog? (receive N) (buzz N))])
      (output (str N))
      (output "!")
    )
    (nl)
    (fizzbuzz (+ N 1) M)
  )
)

(fizzbuzz 1 100)
