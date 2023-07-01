NB. unique list of all y faced dice
udice=: {{ 1+~./:~"1 (#: ,@i.)y#y }}

NB. which dice are less than which other dice?
NB. y here is a result of udice
lthan=: {{ 0>*@(+/)@,@:*@(-/)"1/~ y}}

NB. "less than loops" length x, for y sided non-transitive dice
cycles=: {{
  ud=. udice y
  lt=. lthan ud
  extend=. [:; lt{{< y,"1 0 y-.~I.m{~{:y }}"1
  r=. ; extend^:(x-1)&.> i.#ud
  ud{~ ~.((i.<./)|.])"1 r #~ lt{~({:,&.>{.)|:r
}}
