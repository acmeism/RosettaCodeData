SIMPLEGUI=: noun define
pc simpleGui;
cc IntegerLabel static;cn "Enter the integer 75000";
cc integer edit;
cc TextLabel static;cn "Enter text";
cc text edit;
cc accept button;cn "Accept";
pshow;
)

simpleGui_run=: wd bind SIMPLEGUI
simpleGui_close=: wd bind 'pclose'
simpleGui_cancel=: simpleGui_close

simpleGui_accept_button=: verb define
  ttxt=. text
  tint=. _". integer
  if. tint ~: 75000 do.
    wdinfo 'Integer entered was not 75000.'
  else.
    simpleGui_close ''
   'simpleGui_text simpleGui_integer'=: ttxt;tint
  end.
)

simpleGui_run''
