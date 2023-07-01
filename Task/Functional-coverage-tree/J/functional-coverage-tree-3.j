merge=: ;@(({.@[,(+}.)~)&.> [: +/\1,_1}.#@>)
unrooted=: ([: merge <@(_1,$:@}.);.1)^:(0<#)
parent=:  unrooted level
parent_cover=: (] (1}.~.parent)}~ 1}. * %&(parent +//. ]) [)^:_
