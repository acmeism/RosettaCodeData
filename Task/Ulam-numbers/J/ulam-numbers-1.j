require'stats'
nextulam=: , {{<./(#~ ({:y)<])(~. #~ 1 = #/.~) +/"1 y{~2 comb #y}}
ulam=: <: { (nextulam^:(<:@(>./)`(1 2"_)))
