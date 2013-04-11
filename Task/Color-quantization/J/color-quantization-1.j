kmcL=:4 :0
  C=. /:~ 256 #.inv ,y  NB. colors
  G=. x (i.@] <.@* %) #C  NB. groups (initial)
  Q=. _  NB. quantized list of colors (initial
  whilst.-. Q-:&<.&(x&*)Q0 do.
    Q0=. Q
    Q=. /:~C (+/ % #)/.~ G
    G=. (i. <./)"1 C +/&.:*: .- |:Q
  end.Q
)
