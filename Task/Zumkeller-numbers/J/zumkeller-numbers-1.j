divisors=: {{ \:~ */@>,{ (^ i.@>:)&.">/ __ q: y }}
zum=: {{
  if. 2|s=. +/divs=. divisors y do. 0
  elseif. 2|y do. (0<k) * 0=2|k=. s-2*y
  else. s=. -:s for_d. divs do. if. d<:s do. s=. s-d end. end. s=0
  end.
}}@>
