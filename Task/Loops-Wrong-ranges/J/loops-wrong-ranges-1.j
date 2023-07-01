genrange=:  {{
  'start stop increment'=. y
  start+increment*i.1+<.(stop-start)%increment
}}
