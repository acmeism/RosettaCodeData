MINWDW=: noun define
pc minwdw;
pas 162 85;pcenter;
)

minwdw_run=: monad define
  wd MINWDW
  wd 'pshow;'
)

minwdw_close=: monad define
  wd'pclose'
)

minwdw_run ''
