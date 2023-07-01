opcode=: {{
  (m+{.y),}.y
:
  x,m opcode y
}}

({{((x)=: y opcode)0}}&>32*i.@#);:'NOP LDA STA ADD SUB BRZ JMP STP'

exec1=: {{
  'cod val'=. 0 32#:pc{mem
  pc=: 32|pc+1
  select. cod
    case. 0 do.                         NB. NOP
    case. 1 do. acc=: val{mem           NB. LDA
    case. 2 do. mem=: acc val} mem      NB. STA
    case. 3 do. acc=: 256|acc+val{mem   NB. ADD
    case. 4 do. acc=: 256|acc-val{mem   NB. SUB
    case. 5 do. pc=: 32|pc[^:(*acc) val NB. BRZ
    case. 6 do. pc=: 32|val             NB. JMP
    case. 7 do. pc=: __                 NB. STP
  end.
}}

exec=: {{
  mem=: 32{.y
  pc=: acc=: 0
  while. 0<:pc do. exec1'' end.
  acc
}}
