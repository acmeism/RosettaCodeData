preproc=: {{
  lines=. <;.2 LF,~CR-.~fread y
  for_ndx. |.I.'load'-:"1 (4&{.@>) lines do.
    line=. ndx{::lines
    try. parse=. ;:line catch. continue. end.
    if. 3~:#parse do. continue. end.
    if. (<'load')~:{.parse do. continue. end.
    if. ''''~:(1;0){::parse do. continue. end.
    lines=. lines ndx}~ <;fread each getscripts_j_ ".1{::parse
  end.
  0!:0;lines
}}
