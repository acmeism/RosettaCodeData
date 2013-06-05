   DropNext=. 1 }. <:@[ |. ]
   MoreThanOne=. 1 < #@]
   WhileMoreThanOne=. (^:MoreThanOne f.) (^:_)
   prisoners=. i.@]

   [ DropNext WhileMoreThanOne prisoners f.
[ (1 }. <:@[ |. ])^:(1 < #@])^:_ i.@]
