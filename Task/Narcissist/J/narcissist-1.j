#!/usr/bin/ijconsole
main=:3 : 0  NB. tested under j602
  self=: '#!/j602/bin/jconsole',LF,'main=:',(5!:5<'main'),LF,'main''''',LF
  echo  self -: stdin''
)
main''
