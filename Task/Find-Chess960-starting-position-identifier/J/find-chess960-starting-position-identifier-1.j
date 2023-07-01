REF=: {{
  'N Q B0 B1'=. 0 6 4 4 #: y
  s=. 'B' (0 1+2*B0,B1)} 8#' '
  s=. 'Q' (Q{I.' '=s)} s
  s=. 'N' ((N{(#~ 2=+/"1)#:i.-32){&I.' '=s)} s
  'RKR' (I.' '=s)} s
}}"0 i.960

c960=: {{ r=. REF i. rplc&((u:9812+i.12);&>12$'KQRBNP') 7 u:deb y assert. r<#REF }}
