val debase64 = fn input =>
let

 infix 2 Worb
 infix 2 Wandb
 fun (p Worb q )  =  Word.orb  (p,q);
 fun (p Wandb q ) =  Word.andb (p,q);

fun decode #"/" =  0wx3F
  | decode #"+" =  0wx3E
  | decode c    =  if Char.isDigit c then Word.fromInt (ord c) +  0wx04
              else if Char.isLower c then Word.fromInt (ord c) - 0wx047
              else if Char.isUpper c then Word.fromInt (ord c) - 0wx041
              else 0wx00 ;

fun convert (a::b::c::d::_) =
         let
            val w = Word.<< (a,0wx12) Worb Word.<< (b,0wx0c) Worb Word.<< (c,0wx06) Worb d
         in
            [Word.>> (w,0wx10), Word.>> ((w Wandb 0wx00ff00),0wx08) , w Wandb 0wx0000ff ]
         end
  | convert _ = [] ;

fun decodeLst []    = []
  | decodeLst ilist = ( convert o  map decode )( List.take (ilist,4) ) @  decodeLst (List.drop (ilist,4))

in

  String.implode ( List.map (chr o Word.toInt) ( decodeLst (String.explode input ))  )

end                                                                 handle Subscript  => "Invalid code\n" ;
