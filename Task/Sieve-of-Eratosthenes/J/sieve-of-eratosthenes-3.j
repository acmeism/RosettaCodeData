sieve=: {{
  r=. 0#t=. y# j=.1
  while. y>j=.j+1 do.
    if. j{t do.
      echo j;(y$j{.1);t=. t > y$j{.1
      r=. r, j
    end.
  end.
}}
