require'format/printf'

(opcodes)=: opcodes=: ;:{{)n
 fetch store push add sub mul div mod lt gt le ge
 eq ne and or neg not jmp jz prtc prts prti halt
}}-.LF

(ndDisp)=: ndDisp=:;:{{)n
 Sequence Multiply Divide Mod Add Subtract Negate Less LessEqual Greater
 GreaterEqual Equal NotEqual Not And Or Prts Assign Prti x If x x x While
 x x Prtc x Identifier String Integer
}}-.LF

ndDisp,.ndOps=:;: {{)n
 x mul div mod add sub neg lt le gt ge eq ne not and or
 x x x x x x x x x x x x x x x x
}} -.LF

load_ast=: {{
  'node_types node_values'=: 2{.|:(({.,&<&<}.@}.)~ i.&' ');._2 y
  1{::0 load_ast ''
:
  node_type=. x{::node_types
  if. node_type-:,';' do. x;a: return.end.
  node_value=. x{::node_values
  if. -.''-:node_value do.x;<node_type make_leaf node_value return.end.
  'x left'=.(x+1) load_ast''
  'x right'=.(x+1) load_ast''
  x;<node_type make_node left right
}}

make_leaf=: ;
make_node=: {{m;n;<y}}
typ=: 0&{::
val=: left=: 1&{::
right=: 2&{::

gen_code=: {{
  if.y-:'' do.'' return.end.
  V=. val y
  W=. ;2}.y
  select.op=.typ y
    case.'Integer'do.gen_int _".V [ gen_op push
    case.'String'do.gen_string V [ gen_op push
    case.'Identifier'do.gen_var V [ gen_op fetch
    case.'Assign'do.gen_var left V [ gen_op store [ gen_code W
    case.;:'Multiply Divide Mod Add Subtract Less LessEqual Greater GreaterEqual Equal NotEqual And Or'do.
      gen_op op [ gen_code W [ gen_code V
    case.;:'Not Negate'do.
      gen_op op [ gen_code V
    case.'If'do.
      p1=. gen_int 0 [ gen_op jz [ gen_code V
      gen_code left W
      if.#right W do.
        p2=. gen_int 0 [ gen_op jmp
        gen_code right W [ p1 patch #object
        p2 patch #object
      else.
        p1 patch #object
      end.
    case.'While'do.
      p1=. #object
      p2=. gen_int 0 [ gen_op jz [ gen_code V
      gen_int p1 [ gen_op jmp [ gen_code W
      p2 patch #object
    case.'Prtc'do.gen_op prtc [ gen_code V
    case.'Prti'do.gen_op prti [ gen_code V
    case.'Prts'do.gen_op prts [ gen_code V
    case.'Sequence'do.
      gen_code W [ gen_code V
    case.do.error'unknown node type ',typ y
  end.
}}

gen_op=:{{
   arg=. boxopen y
   if. -.arg e. opcodes do.
     arg=. (ndDisp i. arg){ndOps
   end.
   assert. arg e. opcodes
   object=: object,opcodes i.arg
}}

gen_int=:{{
   if.#$y do.num=. _ ".y
   else.num=. y end.
   r=. #object
   object=: object,(4#256)#:num
   r
}}

gen_string=: {{
   strings=:~.strings,<y
   gen_int strings i.<y
}}

gen_var=: {{
   vars=:~.vars,<y
   gen_int vars i.<y
}}

patch=: {{ #object=: ((4#256)#:y) (x+i.4)} object }}
error=: {{echo y throw.}}
getint=: _2147483648+4294967296|2147483648+256#.]

list_code=: {{
  r=.'Datasize: %d Strings: %d\n' sprintf vars;&#strings
  r=.r,;strings,each LF
  pc=. 0
  lim=.<:#object
  while.do.
    op=.(pc{object){::opcodes
    r=.r,'%5d %s'sprintf pc;op
    pc=. pc+1
    i=. getint (lim<.pc+i.4){object
    k=. 0
    select.op
      case.fetch;store do.k=.4[r=.r,' [%d]'sprintf i
      case.push do.k=.4[r=.r,'  %d'sprintf i
      case.jmp;jz do.k=.4[r=.r,'    (%d) %d'sprintf (i-pc);i
      case.halt do.r=.r,LF return.
    end.
    pc=.pc+k
    r=.r,LF
  end.
}}

gen=: {{
  object=:strings=:vars=:i.0
  gen_code load_ast y
  list_code gen_op halt
}}
