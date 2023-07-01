approxmin=:3 :0
  seqs=. y{~(A.&i.~ !)#y
  r=.{.seqs
  seqs=.}.seqs
  while.#seqs do.
    for_n. i.-#y do.
      tail=. (-n){. r
      b=. tail -:"1 n{."1 seqs
      if. 1 e.b do.
        j=. b i.1
        r=. r, n}.j{seqs
        seqs=. (<<<j) { seqs
        break.
      end.
    end.
  end.
  r
)
