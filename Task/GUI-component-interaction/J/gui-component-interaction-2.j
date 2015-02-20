INTERACT=: 0 : 0
pc interact closeok;
xywh 6 6 48 12;cc Value edit;
xywh 6 18 48 12;cc increment button;cn "+";
xywh 6 30 48 12;cc random button;cn "?";
pas 6 6;pcenter;
rem form end;
)

interact_run=: 3 : 0
 wd INTERACT
 wd 'set Value 0;'
 wd 'pshow;'
)

interact_close=: 3 : 0
 wd'pclose'
)

interact_Value_button=: 3 : 0
 wd 'set Value ' , ": {. 0 ". Value
)

interact_increment_button=: 3 : 0
 wd 'set Value ' , ": 1 + {. 0 ". Value
)

interact_random_button=: 3 : 0
 if. 0 = 2 wdquery 'Confirm';'Reset to random number?' do.
  wd 'set Value ' , ": ?100
 end.
)
