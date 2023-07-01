task=: {{
  words=. <;._2 fread '/usr/share/dict/words'
  for_word. ;:'accomodate definately goverment occured publically recieve seperate untill wich' do.
    b=.d<:close=. 2{/:~d=. word jarowinkler every words
    echo (;word),':'
    echo ' ',.(":,.b#d),.' ',.>b#words
    echo''
  end.
}}

   task''
accomodate:
 0.0681818 accommodate
 0.0945455 accorporate
 0.0703704 commodate

definately:
 0.0422222 defiantly
 0.0622222 definably
 0.0622222 definedly

goverment:
 0.0833333 govern
 0.0644444 government
 0.0944444 governmental

occured:
  0.105556 occlude
 0.0571429 occur
 0.0952381 occursive

publically:
      0.08 public
 0.0747222 publicity
    0.0525 publicly

recieve:
 0.0592593 reachieve
 0.0333333 receive
 0.0392857 recidive

seperate:
 0.0145833 separate
 0.0405093 separates
 0.0458333 septate

untill:
 0.0333333 until
         0 untill
 0.0333333 untrill

wich:
      0.04 wicht
 0.0533333 winch
 0.0533333 witch
