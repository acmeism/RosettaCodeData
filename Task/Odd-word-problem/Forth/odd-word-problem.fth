: word?  dup [char] . <> over bl <> and ;
: ?quit  dup [char] . = if emit quit then ;
: eatbl  begin dup bl = while drop key repeat ?quit ;
: even   begin word? while emit key repeat ;
: odd    word? if key recurse swap emit then ;
: main   cr key eatbl begin even eatbl space odd eatbl space again ;
