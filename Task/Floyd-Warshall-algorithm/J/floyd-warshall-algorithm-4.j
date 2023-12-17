floydrecon=: verb define
  n=. ($y)$_(I._=,y)},($$i.@#)y
  for_j. i.#y do.
    d=. y <. j ({"1 +/ {) y
    b=. y~:d
    y=. d
    n=. (n*-.b)+b * j{"1 n
  end.
)

task=: verb define
  dist=. floyd y
  next=. floydrecon y
  echo 'pair  dist   path'
  for_i. i.#y do.
    for_k. i.#y do.
      ndx=. <i,k
      if. (i~:k)*_>ndx{next do.
        txt=. (":1+i),'->',(":1+k)
        txt=. txt,_5{.":ndx{dist
        txt=. txt,'    ',":1+i
        j=. i
        while. j~:k do.
          assert. j~:(<j,k){next
          j=. (<j,k){next
          txt=. txt,'->',":1+j
        end.
        echo txt
      end.
    end.
  end.
  i.0 0
)
