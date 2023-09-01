|bottles plurals |
Transcript clear.
bottles:='{1} bottle{2} of beer on the wall
{1} bottle{2} of beer
Take one down, pass it around
{3} bottle{4} of beer on the wall'.
plurals := #('' 's').
99 to: 1 by: -1 do:[:v |
 Transcript show: (bottles format: {(v asString) . (plurals atPin:v) . ((v -1) asString). (plurals atPin:v) }); cr; cr].

Transcript show: 'hic!'; cr.
