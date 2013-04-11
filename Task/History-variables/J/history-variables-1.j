varref_hist_=:'VAR','_hist_',~]
set_hist_=:4 :0
  V=.varref x
  if.0>nc<V do.(<V)=:''end.
  (<V)=.V~,<y
  y
)
getall_hist_=:3 :0
  (varref y)~
)
length_hist_=: #@getall
get_hist_=: _1 {:: getall
