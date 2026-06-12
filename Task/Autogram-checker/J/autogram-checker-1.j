NB. requires uk and us from rosettacode Number_names#J
normalize=: {{ tolower ' '(I.(tolower=toupper)y)}y }}
normalize=: tolower@#~ tolower~:toupper

autogram=: {{
  y=. normalize y
  counts=: #/.~ y
  letters=: counts (], '''s'#~1<[)each~.y
  usgrams=: letters (us@],' ',[)each counts
  ukgrams=: letters (uk@],' ',[)each counts
  */(+./@E.&normalize&y every usgrams) +. +./@E.&normalize&y every ukgrams
}}

NB. we use a different autogram requirement for some cases
normalizep=: tolower@#~ e.&(''',-!') +. tolower~:toupper
normalizep2=: rplc&('apostrophe';'''';'comma';',';'hyphen';'-';'exclamation point';'!')

autogramp=: {{
  y=. normalizep y
  counts=: #/.~ y
  letters=: counts (], '''s'#~1<[)each~.y
  usgrams=: letters (us@],' ',[)each counts
  ukgrams=: letters (uk@],' ',[)each counts
  grams=: (, rplc&('''s';'s')L:0) usgrams,:ukgrams
  grams=: (, }.@rplc&('Zone';'Zsingle')@('Z'&,)L:0) grams
  */+./+./@E.&(normalizep2 Y) every grams
}}
