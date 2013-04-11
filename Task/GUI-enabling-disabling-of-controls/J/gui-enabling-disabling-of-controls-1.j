task_run=: wd bind (noun define)
  pc task nosize;
  xywh 6 30 48 12;cc decrement button;cn "-";
  xywh 6 18 48 12;cc increment button;cn "+";
  xywh 6  6 48 12;cc Value edit; set Value 0;
  pas 6 6;pcenter;
  pshow;
)

task_close=: wd bind 'pclose'

task_Value_button=: update=: verb define
  wd 'set Value ',":n=.{.0".Value
  wd 'setenable Value ',":n=0
  wd 'setenable increment ',":n<10
  wd 'setenable decrement ',":n>0
)

task_increment_button=:verb define
  update Value=:":1+0".Value
)
task_decrement_button=:verb define
  update Value=:":_1+0".Value
)
