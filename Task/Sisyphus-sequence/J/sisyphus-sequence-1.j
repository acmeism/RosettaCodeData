sisyphuseq=: {{
  r=.  1
  P=: _1
  while. y>#r do. p=. {:P
    if. 2|N=. {:r do.
      P=: P, p=. 1+p
      r=. r,N+p:p
    else.
      P=: P, p
      r=. r,-:N
    end.
  end.
}}
