deconv3 =: 4 : 0
 sz  =. x >:@-&$ y                                      NB. shape of z
 poi =.  ,<"1 ($y) ,"0/&(,@i.) sz                       NB. pair of indexes
 t=. /: sc=: , <@(+"1)/&(#: ,@i.)/ ($y),:sz             NB. order of ,y
 T0=. (<"0,x) ,:~ (]/:"1 {.)&.> (<, y) ({:@] ,: ({"1~ {.))&.>  sc <@|:@:>/.&(t&{) poi   NB. set of boxed equations
 T1=. (,x),.~(<0 #~ */sz) (({:@])`({.@])`[})&> {.T0     NB. set of linear equations
 sz $ 1e_8 round ({:"1 %. }:"1) T1
)
round=: [ * <.@%~
