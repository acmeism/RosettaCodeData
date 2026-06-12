longnorep=: {{
  c=. #y
  while. ss=. c ]\ y do.
    cnt=. #@~."1 ss
    if. c e. cnt do. ~.ss#~ c=cnt return. end.
    c=. c-1
  end.
}}
