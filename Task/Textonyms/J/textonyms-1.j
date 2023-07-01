require'regex strings web/gethttp'

strip=:dyad define
  (('(?s)',x);'') rxrplc y
)

fetch=:monad define
  txt=. '.*<pre>' strip '</pre>.*' strip gethttp y
  cutopen tolower txt-.' '
)

keys=:noun define
 2 abc
 3 def
 4 ghi
 5 jkl
 6 mno
 7 pqrs
 8 tuv
 9 wxyz
)

reporttext=:noun define
There are #{0} words in #{1} which can be represented by the digit key mapping.
They require #{2} digit combinations to represent them.
#{3} digit combinations represent Textonyms.
)

report=:dyad define
  x rplc (":&.>y),.~('#{',":,'}'"_)&.>i.#y
)

textonymrpt=:dyad define
  'digits letters'=. |:>;,&.>,&.>/&.>/"1 <;._1;._2 x
  valid=. (#~ */@e.&letters&>) fetch y NB. ignore illegals
  reps=. {&digits@(letters&i.)&.> valid NB. reps is digit seq
  reporttext report (#valid);y;(#~.reps);+/(1<#)/.~reps
)
