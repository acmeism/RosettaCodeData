stemleafX=: monad define
  leaves=. 10 | y
  stems=. y <.@:% 10
  leaves=. stems </. leaves                           NB. group leaves by stem
  (<"0 ~.stems),.leaves
)

showStemLeafX=: monad define
  'stems leaves'=. (>@{. ; <@{:)@|: stemleafX /:~ y
  xstems=. (<./ ([ + i.@>:@-~ ) >./) stems            NB. stems including those with no leaves
  xleaves=. (xstems e. stems) #inv leaves             NB. expand leaves to match xstems
  (": ,.xstems) ; ":&> xleaves
)
