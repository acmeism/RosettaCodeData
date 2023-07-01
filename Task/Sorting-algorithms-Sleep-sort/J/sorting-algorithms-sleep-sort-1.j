scheduledumb=: {{
  id=:'dumb',":x:6!:9''
  wd 'pc ',id
  (t)=: u {{u y[erase n}} t=. id,'_timer'
  wd 'ptimer ',":n p.y
}}


ssort=: {{
  R=: ''
  poly=. 1,>./ y
  poly{{ y{{R=:R,m[y}}scheduledumb m y}}"0 y
  {{echo R}} scheduledumb poly"0 >:>./ y
  EMPTY
}}
