stripp=:3 :0
  ('/*';'*/') stripp y
:
  'open close'=. x
  marks=. (+./(-i._1+#open,close)|."0 1 open E. y) - close E.&.|. y
  y #~  -. (+._1&|.) (1 <. 0 >. +)/\.&.|. marks
)
