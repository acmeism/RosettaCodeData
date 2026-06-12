genboard=: {{
  safelen=:2*len=: {.y
  shape=: 2$len
  board=: shape$0
  safeshape=: ,~safelen
  c=:,coords=: safeshape#.shape#:i.shape
  qrow=. i:{.shape-1
  qcol=. qrow*safelen
  qdiag1=. qrow+qcol
  qdiag2=. qrow-qcol
  queen=: ~.qrow,qcol,qdiag1,qdiag2
  k1=. ,(1 _1*safelen)+/2 _2
  k2=. ,(2 _2*safelen)+/1 _1
  knight=: 0,k1,k2
  bishop=: ~.qdiag1,qdiag2
  row=. i.len
  first=: ~.,coords#"1~(row<:>.<:len%2) * >:/~ row
  EMPTY
}}

placebishops=: {{coords #&,~ 1 (<.-:len)} board}}

placequeens=: {{
  N=. 0
  while. N=. N+1 do.
    assert. N<:#c
    for_seq. first do.
      board=. coords e.queen+seq
      if. 0 e.,board do.
         if. 1<N do.
           seq=. board queen place1 N seq
           if. #seq do.
             assert. N-:#seq
             assert. */c e.,queen+/seq
             seq return.
           end.
         end.
      else.
        seq return.
      end.
    end.
  end.
  EMPTY
}}

placeknights=:{{
  N=. 0
  while. N=. N+1 do.
    assert. N<:#c
    for_seq. c do.
      board=. coords e.knight+seq
      if. 0 e.,board do.
         if. 1<N do.
           seq=. board knight place1 N seq
           if. #seq do.
             assert. N-:#seq
             assert. */c e.,knight+/seq
             seq return.
           end.
         end.
      else.
        seq return.
      end.
    end.
  end.
  EMPTY
}}

NB. x: board with currently attacked locations marked
NB. m: move targets
NB. n: best sequence length so far
NB. y: coords of placed pieces
place1=: {{
  for_seq. y,"1 0(#~ (>./y) < ])(,0=x)#c do.
    board=. x>.coords e.,m+/seq
    if. 0 e.,board do.          NB. further work needed?
       if.n>#seq do.
         seq=. board m place1 n seq
         if.#seq do.seq return.end.
       end.
    else. seq return.
    end.
  end.
  EMPTY
}}

task=: {{
  B=:Q=:K=:i.0
  for_order.1+i.y do.
    genboard order
    B=: 1j1#"1'.B'{~coords e.b=. placebishops ''
    Q=: 1j1#"1'.Q'{~coords e.q=. placequeens ''
    if. 8>order do.
      K=: 1j1#"1'.K'{~coords e.k=. placeknights ''
      echo (":B;Q;K),&.|:>(' B: ',":#b);(' Q: ',":#q);' K: ',":#k
    else.
      echo (":B;Q),&.|:>(' B: ',":#b);' Q: ',":#q
    end.
  end.
}}
