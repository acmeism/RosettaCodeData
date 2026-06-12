wrdcmp=: {{
  yw=. ;(] , ({.~1<.#)@-.)&.>/(<@I.y=/~x#~y~:x),<I.x=y
  2 (I.x=y)} 1 yw} (#y)#0
}}

assert 1 1 2 0 0-: 'allow' wrdcmp 'lolly'
assert 0 0 2 2 2-: 'bully' wrdcmp 'lolly'
assert 0 0 0 1 0-: 'robin' wrdcmp 'alert'
assert 0 2 1 2 0-: 'robin' wrdcmp 'sonic'
assert 2 2 2 2 2-: 'robin' wrdcmp 'robin'
assert 0 0 2 1 0-: 'mamma' wrdcmp 'nomad'
assert 0 1 2 0 0-: 'nomad' wrdcmp 'mamma'
