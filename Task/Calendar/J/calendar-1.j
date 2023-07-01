require 'dates format'               NB. J6.x
require 'dates general/misc/format'  NB. J7.x
calBody=: (1 1 }. _1 _1 }. ":)@(-@(<.@%&22)@[ ]\ calendar@])
calTitle=: (<: - 22&|)@[ center '[Insert Snoopy here]' , '' ,:~ ":@]
formatCalendar=: calTitle , calBody
