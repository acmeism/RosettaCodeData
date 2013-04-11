bfsjt0=: _1 - i.
lookingat=: 0 >. <:@# <. i.@# + *
next=: | >./@:* | > | {~ lookingat
bfsjtn=: (((] <@, ] + *@{~) | i. next) C. ] * _1 ^ next < |)^:(*@next)
