doubleLoop=: {{
  for_row. i.#y do.
    for_col. i.1{$y do.
      echo t=.(<row,col) { y
      if. 20=t do. return. end.
    end.
  end.
}}
