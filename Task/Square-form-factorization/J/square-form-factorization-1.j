sqff=: {{
  s=. <.%:y
  if. y=*:s do. s return. end.
  for_D. (x:y)*/:~*/@>,{1,each}.p:i.5 do.
    if. -.'integer'-:datatype D=. x:inv D do. break. end.
    P=. <.%:D
    Q=. 1, D-P*P
    lim=. <:6*<.%:2*s
    for_i. }.i.lim do.
      b=. <.(+/0 _1{P)%{:Q
      P=. P,|(b*{:Q)-{:P
      Q=. Q,|(_2{Q)+b*-/_2{.P
      if. 2|i do. if. (=<.&.%:){:Q do. break. end. end.
    end.
    if. i>:lim do. continue. end.
    Q=. <.%:{:Q
    b=. <.(-/0 _1{P)%Q
    P=. ,(b*Q)+{:P
    Q=. Q, <.|(D-*:P)%Q
    whilst. ~:/_2{.P do.
      b=. <.(+/0 _1{P)%{:Q
      P=. P,|(b*{:Q)-{:P
      Q=. Q,|(_2{Q)+b*-/_2{.P
    end.
    f=. y+.x:_2{Q
    if. -. f e. 1,y do. f return. end.
  end.
  1
}}
