outbuf=: ''
emit=:{{
  outbuf=: outbuf,y
  if.LF e. outbuf do.
    ndx=. outbuf i:LF
    echo ndx{.outbuf
    outbuf=: }.ndx}.outbuf
  end.
}}

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
typ=: 0&{::
val=: left=: 1&{::
right=: 2&{::
make_node=: {{m;n;<y}}
id2var=: 'var_',rplc&('z';'zz';'_';'_z')

interp=:{{
  if.y-:'' do.'' return.end.
  V=. val y
  W=. ;2}.y
  select.typ y
    case.'Integer'do._".V
    case.'String'do.rplc&('\\';'\';'\n';LF) V-.'"'
    case.'Identifier'do.".id2var V
    case.'Assign'do.''[(id2var left V)=: interp W
    case.'Multiply'do.V *&interp W
    case.'Divide'do.V (*&* * <.@%&|)&interp W
    case.'Mod'do.V (*&* * |~&|)&interp W
    case.'Add'do.V +&interp W
    case.'Subtract'do.V -&interp W
    case.'Negate'do.-interp V
    case.'Less'do.V <&interp W
    case.'LessEqual'do.V <:&interp W
    case.'Greater'do.V >&interp W
    case.'GreaterEqual'do.V >&interp W
    case.'Equal'do.V =&interp W
    case.'NotEqual'do.V ~:&interp W
    case.'Not'do.0=interp V
    case.'And'do.V *.&interp W
    case.'Or' do.V +.&interp W
    case.'If'do.if.interp V do.interp left W else.interp right W end.''
    case.'While'do.while.interp V do.interp W end.''
    case.'Prtc'do.emit u:interp V
    case.'Prti'do.emit rplc&'_-'":interp V
    case.'Prts'do.emit interp V
    case.'Sequence'do.
      interp V
      interp W
      ''
    case.do.error'unknown node type ',typ y
  end.
}}
