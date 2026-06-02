negate  0    ;== 0
negate -1    ;== 1
negate 1:0:0 ;== -1:0:0
negate -1x2  ;== 1x-2
negate $100  ;== -$100
;; or
1 + complement -42       ;== 42
complement true          ;== false
complement 2#{0000 0011} ;== 2#{1111 1100}
