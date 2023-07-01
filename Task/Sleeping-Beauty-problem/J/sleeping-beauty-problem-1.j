sb=: {{
  monday=. ?2
  if. -. monday do.
    tuesday=. ?2
    <monday,tuesday
  else.
    <monday
  end.
}}
