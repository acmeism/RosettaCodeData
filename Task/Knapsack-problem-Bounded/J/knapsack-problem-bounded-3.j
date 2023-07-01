dyn=:3 :0
  m=. 0$~1+400,+/pieces NB. maximum value cache
  b=. m                 NB. best choice cache
  opts=.+/\0,pieces     NB. distinct item counts before each piece
  P=. */\1+0,pieces   NB. distinct possibilities before each piece
  for_w.1+i.400 do.
    for_j.i.#pieces do.
      n=. i.1+j{pieces         NB. possible counts for this piece
      W=. n*j{weights          NB. how much they weigh
      s=. w>:W                 NB. permissible options
      v=. s*n*j{values         NB. consequent values
      base=. j{opts            NB. base index for these options
      I=. <"1 w,.n+base        NB. consequent indices
      i0=. <w,base             NB. status quo index
      iN=. <"1 (w-s*W),.base   NB. predecessor indices
      M=. >./\(m{~i0)>.v+m{~iN NB. consequent maximum values
      C=. (n*j{P)+b{~iN        NB. unique encoding for each option
      B=. >./\(b{~i0)>. C * 2 ~:/\ 0,M NB. best options, so far
      m=. M I} m       NB. update with newly computed maxima
      b=. B I} b       NB. same for best choice
    end.
  end.
  |.(1+|.pieces)#:{:{:b
)

   dyn''
1 1 1 0 2 0 3 0 1 0 1 0 0 0 0 0 1 1 1 0 1 0
