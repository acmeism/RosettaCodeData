levalign=:4 :0
  assert. x <:&# y
  D=. x +/&i.&>:&# y
  for_i. 1+i.#x do.
    for_j. 1+i.#y do.
      if. ((<:i){x)=(<:j){y do.
        D=. (D {~<<:i,j) (<i,j)} D
      else.
        min=. 1+<./D{~(i,j) <@:-"1#:1 2 3
        D=. min (<i,j)} D
      end.
    end.
  end.
  A=. B=. ''
  ij=. x ,&# y
  while. */ij do.
    'd00 d01 d10 d11'=. D{~ ij <@:-"1#:i.4
    'x1 y1'=. (ij-1){each x;y
    if. d00 = d11+x1~:y1 do.
      A=. A,x1 [ B=. B,y1 [ ij=. ij-1
    elseif. d00 = 1+d10 do.
      A=. A,x1 [ B=. B,'-'[ ij=. ij-1 0
    elseif. d00 = 1+d01 do.
      A=. A,'-'[ B=. B,y1 [ ij=. ij-0 1
    end.
  end.
  A,:&|.B
)
