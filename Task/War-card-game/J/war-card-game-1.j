DECK=: '2 3 4 5 6 7 8 9 10 J K Q A' (,' of ',])&.>/&cut '♣ ♦ ♥ ♠'
rank=: DECK {{ {."1 ($m)#:(,m) i. y }}
shuffle=: {~ ?~@#
deal=: _26 ]\ shuffle@,@DECK
cardwar=: {{
  TURNS=: 0
  'P1 P2'=: <each deal''
  while. 0<P1 *&# P2 do. turn TURNS=: TURNS+1 end.
  after=. ' after ',TURNS,&":' turn','s'#~1~:TURNS
  if. #P1 do. 'Player 1 wins', after
  elseif. #P2 do. 'Player 2 wins', after
  else. 'Tie',after end.
}}
plays=: {{ ((m)=: }.".m)](echo n,~(m,' plays '),;'nothing'&[^:(0=#@]){.".m)]({.".m) }}
turn=: {{
  c=. (b=. 'P2' plays''),(a =. 'P1' plays'')
  while. a =&rank b do.
    if. 0=P1 *&# P2 do. echo 'No more cards to draw' return. end.
    c=. c, (a=. 'P1' plays''),(b =. 'P2' plays''), 'P1' plays' face down', 'P2' plays' face down'
  end.
  ('P',":1+a <&rank b) takes ({~ ?~@#)c-.a:
}}
takes=: {{
  (m)=: (".m),y
  echo m,' takes ',;(<' and ') _2}}.,(<', '),.y
  echo''
}}
