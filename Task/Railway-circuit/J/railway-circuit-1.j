NB. is circuit valid?
vrwc=: {{ */1=({:,1++/)*/\^j.1r6p1*y }}"1

NB. canonical form for circuit:
crwc=: {{ {.\:~,/(i.#y)|."0 1/(,|.)y,:-y }}"1

NB. all valid railway circuits with y 30 degree curves
rwc=: {{
  r=. EMPTY
  h=. -:y
  sfx=. (]/.~ 2|+/"1)#:i.2^h
  for_pfx. (-h){."1 #:i.2^_3+h do. p=.2|+/pfx
    r=. r,~.crwc (#~ vrwc) _1^pfx,"1 p{sfx
  end.
  'SLR'{~~.r
}}

NB. all valid railway circuits with y 30 degree curves and x straight segments
rwcs=: {{
  r=. EMPTY
  h=. -:y+x
  sfx=. (h#3)#:i.3^h
  for_pfx. sfx do.
    r=. r,~.crwc (#~ vrwc) (#~ x= 0 +/ .="1]) 0 1 _1{~pfx,"1 sfx
  end.
  'SLR'{~~.r
}}
