OPS=: 'nop lda sta add sub brz jmp stp'

assemble1=: {{
  y=. tolower y
  ins=. {.;:y-.":i.10
  cod=. 8|(;:OPS) i. ins
  val=. {.0".y-.OPS
  if. *cod do.
    assert. 32>val
    val+32*cod
  else.
    assert. 256>val
    val
  end.
}}

assemble=: {{
  if. 0=L. y do.
    delim=. {.((tolower y)-.(":i.10),;OPS),LF
    y=. delim cut y
  end.
  code=. assemble1@> y
  mem=: code (i.#code)} 32#0
}}

exec1=: {{
  'cod val'=. 0 32#:pc{mem
  pc=: 32|pc+1
  select. cod
    case. 0 do.
    case. 1 do. acc=: val{mem
    case. 2 do. mem=: acc val} mem
    case. 3 do. acc=: 256|acc+val{mem
    case. 4 do. acc=: 256|acc-val{mem
    case. 5 do. pc=: 32|pc[^:(*acc) val
    case. 6 do. pc=: 32|val
    case. 7 do. pc=: __
  end.
}}

exec=: {{
  pc=: acc=: 0
  while. 0<:pc do. exec1'' end.
  acc
}}
