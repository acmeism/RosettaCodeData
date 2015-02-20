   NB. Dynamic programming method...

   o=. @:                NB. Composing verbs
   success=. {:o[ = {.o] NB. Is the last letter of the left word equal to the first of the right?
   join=. [ , ' ' , ]    NB. Joining the left and right words
   cp=. {@(,&<)          NB. Cartesian product

   amb=. join&>/&.> o ((success&>/ &> # ]) o , o cp)f.
   amb NB. Showing the point-free code...
([ , ' ' , ])&>/&.>@:((({:@:[ = {.@:])&>/&> # ])@:,@:({@(,&<)))
