dgt=: 10&#.inv
dgrp=: </.~ /:~"1&.dgt
pgrp=: {{dgrp p:(+ i.)/(-/)\ p:inv 0 _1+10^_1 0+y}}
big=: \: +/@>
largest=: 0 {:: big
