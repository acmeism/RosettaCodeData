coclass 'integerPool'
require 'jmf'
create=: monad define
  Lim=: y*SZI_jmf_
  Next=: -SZI_jmf_
  Pool=: mema Lim
)

destroy=: monad define
  memf Pool
  codestroy''
)

alloc=: monad define
  assert.Lim >: Next=: Next+SZI_jmf_
  r=.Pool,Next,1,JINT
  r set y
  r
)

get=: adverb define
  memr m
)

set=: adverb define
  y memw m
)
