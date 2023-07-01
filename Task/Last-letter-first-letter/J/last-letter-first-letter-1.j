pokenames=: ;:0 :0-.LF
 audino bagon baltoy banette bidoof braviary bronzor carracosta charmeleon
 cresselia croagunk darmanitan deino emboar emolga exeggcute gabite
 girafarig gulpin haxorus heatmor heatran ivysaur jellicent jumpluff kangaskhan
 kricketune landorus ledyba loudred lumineon lunatone machamp magnezone mamoswine
 nosepass petilil pidgeotto pikachu pinsir poliwrath poochyena porygon2
 porygonz registeel relicanth remoraid rufflet sableye scolipede scrafty seaking
 sealeo silcoon simisear snivy snorlax spoink starly tirtouga trapinch treecko
 tyrogue vigoroth vulpix wailord wartortle whismur wingull yamask
)

seqs=: 3 :0
  links=. <@I. _1 =/&({&>&y) 0
  next=. ,.i.#links
  while.#next do.
     r=. next
     assert. 1e9>*/8,$r
     next=. (#~ (-: ~.)"1) >;<@(] <@,"1 0 links {::~ {:)"1 r
  end.
  r
)
