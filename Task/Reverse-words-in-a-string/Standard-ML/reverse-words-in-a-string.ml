val lines = [
  " ---------- Ice and Fire ------------ ",
  "                                      ",
  " fire, in end will world the say Some ",
  " ice. in say Some                     ",
  " desire of tasted I've what From      ",
  " fire. favor who those with hold I    ",
  "                                      ",
  " ... elided paragraph last ...        ",
  "                                      ",
  " Frost Robert ----------------------- "
]

val revWords = String.concatWith " " o rev o String.tokens Char.isSpace

val () = app (fn line => print (revWords line ^ "\n")) lines
