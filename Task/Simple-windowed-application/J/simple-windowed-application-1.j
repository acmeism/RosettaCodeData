simple_run=: {{
  simple_clicks=: 0   NB. initialize accumulator
  wd {{)n
    pc simple closeok escclose;
    cc click button;cn "Click me";
    cc message static;cn "There have been no clicks yet.";
    pshow;
}}}}
simple_run''

simple_click_button=: {{wd 'set message text Button-use count: ',": simple_clicks=: 1+simple_clicks}}
