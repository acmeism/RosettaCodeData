import macros,sugar,strformat
#macro to take a nested tuple and return a type
#e.g. (int,(int,int))=>(string,(string,string))
proc intstr(n: NimNode): NimNode =
  if n.kind == nnkSym:
    return ident("string")
  result = nnkPar.newNimNode()
  for i in 1..<n.len:
    result.add(intstr(n[i]))

macro tuptype(t: typed): untyped = intstr(t.getType)


proc replace(t: tuple | int, p: openArray[string]): auto =
  when t is int: (if t in 0..<p.len: p[t] else: "nil")
  else:
    var res: tuptype(t)
    for k, v in t.fieldpairs:
      #k will be 'Field0', so we convert to an integer index
      res[k[^1].int - '0'.int] = replace(v, p)
    return res
when isMainModule:
  let p = collect(for i in 0..5: &"payload{i}")

  let tplt1 = ((1,2),(3,4,1),5)
  let tplt2 = ((1,2),(3,4,1),6)
  echo replace(tplt1, p)
  echo replace(tplt2, p)
