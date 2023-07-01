   Qs=:0 1 1
   Q=: verb define
     n=. >./,y
     while. n>:#Qs do.
       Qs=: Qs,+/(-_2{.Qs){Qs
     end.
     y{Qs
)
