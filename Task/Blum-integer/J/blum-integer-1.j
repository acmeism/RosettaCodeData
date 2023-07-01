isblum=: {{
  ab=. q: y
  if. 2= #ab do.
    if. </ab do.
      *./3=4|ab
    else. 0 end.
  else. 0 end.
}}"0

blumseq=: {{
  r=. (#~ isblum) }.i.b=. 1e4
  while. y>#r do.
    r=. r, (#~ isblum) b+i.1e4
    b=. b+1e4
  end.
  y{.r
}}
