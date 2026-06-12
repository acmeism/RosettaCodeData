wrdcmp=: {{
  yw=.gr=. I.x=y
  key=. '#' gr} x
  for_ch.y do.
    if.ch e. key do.
      key=. '#' (key i.ch)} key
      yw=. yw, ch_index
    end.
  end.
  2 gr} 1 yw} (#y)#0
}}
