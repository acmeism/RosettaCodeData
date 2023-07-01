'LEFT CENTER RIGHT'=: i.3                NB. justification constants

NB.* alignCols v Format delimited text in justified columns
NB. y:          text to format
NB.                 rows marked by last character in text
NB.                 columns marked by $
NB. optional x: justification. Default is LEFT
NB. result:     text table
alignCols=: verb define
  LEFT alignCols y                       NB. default
:
  global=. dyad def'9!:x y'each
  oldbox=. 6 16 global '';''             NB. save settings
  7 17 global (11#' ');,~x               NB. apply new settings
  result=. _2{:\ ": <;._2 @:,&'$';._2 y  NB. parse & format text
  7 17 global oldbox                     NB. restore settings
  result
)
