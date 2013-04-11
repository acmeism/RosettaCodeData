levenshtein=:4 :0
  D=. x +/&i.&>:&# y
  for_i.1+i.#x do.
    for_j.1+i.#y do.
      if. ((<:i){x)=(<:j){y do.
        D=.(D {~<<:i,j) (<i,j)} D
      else.
        min=. 1+<./D{~(i,j) <@:-"1#:1 2 3
        D=. min (<i,j)} D
      end.
    end.
  end.
  {:{:D
)
