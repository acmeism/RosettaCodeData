INTERACT=: noun define
pc interact;
cc Value edit center;
cc increment button;cn "Increment";
cc random button;cn "Random";
pas 6 6;pcenter;
)

interact_run=: verb define
 wd INTERACT
 wd 'set Value text 0;'
 wd 'pshow;'
)

interact_cancel=: interact_close=: verb define
 wd'pclose'
)

interact_Value_button=: verb define
 wd 'set Value text ' , ": {. 0 ". Value
)

interact_increment_button=: verb define
 wd 'set Value text ' , ": 1 + {. 0 ". Value
)

interact_random_button=: verb define
 if. 2 = 2 3 wdquery 'Confirm';'Reset to random number?' do.
  wd 'set Value text ' , ": ?100
 end.
)
