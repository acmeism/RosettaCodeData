map String.compare [ ("one","one"),
   ("one","two"),
   ("one","Two"),
   ("one",String.map Char.toLower "Two")
   ] ;

val it = [EQUAL, LESS, GREATER, LESS]: order list

"one" <> "two" ;
val it = true: bool
