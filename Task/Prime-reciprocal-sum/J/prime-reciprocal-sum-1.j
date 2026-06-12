taskfmt=: {{
  if. 40<#t=. ":y do.
    d=. ":#t
    (20{.t),'..',(_20{.t),' (',d,' digits)'
  else.
    t
  end.
}}@>
