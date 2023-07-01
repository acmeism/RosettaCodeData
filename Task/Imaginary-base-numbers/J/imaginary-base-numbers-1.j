ibdec=: {{
  0j2 ibdec y
:
  digits=. 0,".,~&'36b'@> tolower y -.'. '
  (x #. digits) % x^#(}.~ 1+i.&'.')y-.' '
}}"1

ibenc=: {{
  0j2 ibenc y
:
  if.0=y do.,'0' return.end.
  sq=.*:x assert. 17 > sq
  step=. }.,~(1,|sq) +^:(0>{:@]) (0,sq) #: {.
  seq=. step^:(0~:{.)^:_"0
  're im0'=.+.y
  'im imf'=.(sign,1)*(0,|x)#:im0*sign=.*im0
  frac=. ,hfd (imf*|x)-.0 if.#frac do.frac=.'.',frac end.
  frac,~(}.~0 i.~_1}.'0'=]) }:,hfd|:0 1|."0 1 seq re,im
}}"0
