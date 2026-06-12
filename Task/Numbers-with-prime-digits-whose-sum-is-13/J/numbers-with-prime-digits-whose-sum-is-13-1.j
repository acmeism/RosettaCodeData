ps13=: {{
  seq=. 0#,D=. ,Q=. ":,.p:i.4
  while. #Q do.
    N=. ,/D,"0 1/Q
    i=. +/"1"."0 N
    Q=. (12>i)#N
    seq=. seq,,".(13=i)#N
  end.
}}0
