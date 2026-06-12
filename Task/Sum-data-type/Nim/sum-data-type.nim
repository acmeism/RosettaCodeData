type
  UnionKind = enum nkInt,nkFloat,nkString
  Union = object
    case kind:UnionKind
    of nkInt:
      intval:int
    of nkFloat:
      floatval:float
    of nkString:
      stringval:string
proc `$`(u:Union):string =
  case u.kind
  of nkInt:
    $u.intval
  of nkFloat:
    $u.floatval
  of nkString:
    '"' & $u.stringval & '"'
when isMainModule:
  let
    u = Union(kind:nkInt,intval:3)
    v = Union(kind:nkFloat,floatval:3.14)
    w = Union(kind:nkString,stringval:"pi")
  echo [u,v,w]
