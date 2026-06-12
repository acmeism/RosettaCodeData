coclass 'vlist'

off=: 0
lastsz=: 1
(current=: 'b1')=: 0

size=: {{ lastsz+off-1 }}

get=: {{
  assert. y>:0 ['negative index not supported'
  assert. y<size 'index too large'
  bi=. #:y+1     NB. work with binary representation of origin 1 index
  b=. #.(#bi){.1 NB. most significant bit (the reason for origin 1)
  i=. #.}.bi     NB. rest of index
  i{do 'b',":b
}}"0

unshift=: {{
  (current)=: y off} do current
  off=: 1+off
  if. off=lastsz do.
    off=: 0
    lastsz=: 2*lastsz
    current=: 'b',":lastsz
    (current)=: lastsz#0
  end.
  y
}}"0

shift=: {{
  assert. 0<size 'vlist empty'
  off=: off-1
  if. 0>off do.
    erase current
    lastsz=: <.-:lastsz
    off=: lastsz-1
    current=: 'b',":lastsz
  end.
  r=. off{do current
}}
