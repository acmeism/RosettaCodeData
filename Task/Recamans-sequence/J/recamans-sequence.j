average =: +/ % #
NB. extra_data u Bsearch bounds
NB. Bsearch returns narrowed bounds depending if u return 0 (left) or 1 (right)
NB. u is called as extra_data u index
NB.   or as        index u index
NB. u is invoked as a dyad
Bsearch =: 1 :'((0 1 + (u <.@:average)) { ({. , <.@:average, {:)@:])^:_'
