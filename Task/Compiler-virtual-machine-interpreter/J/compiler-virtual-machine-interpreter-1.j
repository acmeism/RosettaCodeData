(opcodes)=: opcodes=: ;:{{)n
 fetch store push add sub mul div mod lt gt le ge
 eq ne and or neg not jmp jz prtc prts prti halt
}}-.LF

unpack=: {{
  lines=. <;._2 y
  'ds0 ds s0 s'=.;:0{::lines
  assert.'Datasize:Strings:'-:ds0,s0
  vars=: (".ds)#0
  strings=: rplc&('\\';'\';'\n';LF)L:0 '"'-.L:0~(1+i.".s){lines
  object=: ;xlate L:1 (;:'()[]') -.~L:1 ;:L:0 '-_' rplc~L:0 (1+".s)}.lines
  outbuf=: stack=: i.0
}}

xlate=: {{
  if.2<#y do.
    (opcodes i. 1{y),(4#256)#:".2{::y
  else.
    opcodes i. 1{y
  end.
}}

NB. ensure we maintain 32 bit signed int representation
signadj=: _2147483648+4294967296|2147483648+]
getint=: signadj@(256 #. ])

PUSH=: {{ stack=:stack,signadj y }}
POP=:  {{ (stack=: _1 }. stack) ] _1 {  stack }}
POP2=: {{ (stack=: _2 }. stack) ] _2 {. stack }}
emit=:{{
  outbuf=: outbuf,y
  if.LF e. outbuf do.
    ndx=. outbuf i:LF
    echo ndx{.outbuf
    outbuf=: }.ndx}.outbuf
  end.
}}

run_vm=: {{
  unpack y
  stack=: i.pc=:0
  lim=. <:#object
  while.do.
    pc=: pc+1 [ op=: (pc { object){opcodes
    i=. getint (lim<.pc+i.4) { object
    k=. 0
    select.op
      case.fetch do. k=.4 [PUSH i{vars
      case.store do. k=.4 [vars=: (POP'') i} vars
      case.push do.  k=.4 [PUSH i
      case.add do. PUSH +/POP2''
      case.sub do. PUSH -/POP2''
      case.mul do. PUSH */POP2''
      case.div do. PUSH<.%/POP2''
      case.mod do. PUSH |~/POP2''
      case.lt  do. PUSH </POP2''
      case.le  do. PUSH <:/POP2''
      case.eq  do. PUSH =/POP2''
      case.ne  do. PUSH ~:/POP2''
      case.ge  do. PUSH >:/POP2''
      case.gt  do. PUSH >/POP2''
      case.and do. PUSH */0~:POP2''
      case.or  do. PUSH +./0~:POP2''
      case.neg do. PUSH -POP''
      case.not do. PUSH 0=POP''
      case.jmp do. k=. i
      case.jz  do. k=. (0=POP''){4,i
      case.prtc do. emit u:POP''
      case.prts do. emit (POP''){::strings
      case.prti do. emit rplc&'_-'":POP''
      case.halt do. if.#outbuf do.echo outbuf end.EMPTY return.
    end.
    pc=: pc+k
  end.
}}
