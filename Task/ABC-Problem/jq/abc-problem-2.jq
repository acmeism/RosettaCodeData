def task:
  ["BO","XK","DQ","CP","NA","GT","RE","TG","QD","FS",
   "JW","HU","VI","AN","OB","ER","FS","LY","PC","ZM"] as $blocks
  | ("A", "BARK","BOOK","TREAT","COMMON","SQUAD","CONFUSE")
  | "\(.) : \( .|abc($blocks) )" ;task
