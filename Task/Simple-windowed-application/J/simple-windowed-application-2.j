SIMPLEAPP=: noun define
pc simpleApp;
cc inc button;cn "Click me";
cc shownText static;cn "There have been no clicks yet.";
)

simpleApp_run=: verb define
  wd SIMPLEAPP
  simpleApp_accum=: 0   NB. initialize accumulator
  wd 'pshow;'
)

simpleApp_inc_button=: verb define
  wd 'set shownText text ','Button-use count:  ',": simpleApp_accum=: >: simpleApp_accum
)

simpleApp_close=: wd bind 'pclose'
simpleApp_cancel=: simpleApp_close

simpleApp_run''
