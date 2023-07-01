T=:TEMPLATE=: noun define
   (X), (X), bo-b(Y)
   Banana-fana fo-f(Y)
   Fee-fi-mo-m(Y)
   (X)!
)

nameGame=: monad define
 X=. y
 Y=. tolower }.^:('aeiouAEIOU' -.@:e.~ {.) y
 heady=. tolower {. y
 t=. TEMPLATE -. '()'
 'ix iy'=. I. 'XY' =/ t
 tbox=. ;/ t
 match=. heady = (<: iy){::"0 _ tbox
 remove =. match # iy
 special_rule_box=. a: (<: remove)}tbox
 ybox=. (< Y) iy} special_rule_box
 XBox=. (< X) ix} ybox
 ; XBox
)
