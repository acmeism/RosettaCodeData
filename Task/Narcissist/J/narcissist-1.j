#!/j602/bin/jconsole
main=:3 : 0
  self=: '#!/j602/bin/jconsole',LF,'main=:',(5!:5<'main'),LF,'main''''',LF
  echo  self -: stdin''
)
main''
