val demo = fn () =>
let
 open IntInf

 val zero        =  fn f       =>  fn x => x ;
 fun succ  n     =  fn f       =>  f o (n f)  ;                                                   (* successor *)
 val rec church  =  fn 0       =>  zero
                       | n     =>  succ ( church (n-1) ) ;                                        (* natural to church numeral *)
 val natural     =  fn churchn =>  churchn  (fn x => x+1) (fromInt 0) ;                           (* church numeral to natural *)

 val mult        =  fn cn    =>  fn cm   =>  cn o cm  ;
 val add         =  fn cn    =>  fn cm   =>  fn f => (cn f) o (cm  f) ;
 val exp         =  fn cn    =>  fn em   =>  em cn;

 in

   List.app    (fn i=>print( (toString i)^"\n" ))     ( List.map natural
       [ add (church 3) (church 4)  , mult (church 3) (church 4) , exp (church 4) (church 3) , exp (church 3) (church 4) ]  )

end;
