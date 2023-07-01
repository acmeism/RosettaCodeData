task_run=: wd bind (noun define)
  pc task nosize;
  cc decrement button;cn "Decrement";
  cc increment button;cn "Increment";
  cc Value edit center;set Value text 0;
  set decrement enable 0;
  pas 6 6;pcenter;
  pshow;
)

task_cancel=: task_close=: wd bind 'pclose'

task_Value_button=: update=: verb define
  wd 'set Value text ', ": n=. {. 0 ". Value
  wd 'set Value enable ', ": n=0
  wd 'set increment enable ', ": n<10
  wd 'set decrement enable ', ": n>0
)

task_increment_button=:verb define
  update Value=: ": 1 + 0 ". Value
)

task_decrement_button=:verb define
  update Value=: ": _1 + 0 ". Value
)
