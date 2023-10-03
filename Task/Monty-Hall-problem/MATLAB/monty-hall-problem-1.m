wins = ceil(3*rand(1e8,1)) - ceil(3*rand(1e8,1))
mprintf('chance to win for staying:  %1.6f %%\nchance to win for changing: %1.6f %%', 100*length(wins(wins==0))/length(wins), 100*length(wins(wins<>0))/length(wins))
