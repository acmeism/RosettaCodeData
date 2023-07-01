import macros, fusion/matching
{.experimental: "caseStmtMacros".}
macro listMethods(modulepath:static string, typename): untyped =
  let module = parseStmt(staticRead(modulepath))
  var procs: seq[string]
  for stmt in module:
    case stmt
      of (kind: in {nnkFuncDef,nnkProcDef..nnkIteratorDef}):#any kind of methody thing
        case stmt
        of [
          PostFix[_, @name],#only exported procs
          _,
          _,
          FormalParams[
            _, #return type
            IdentDefs[ #first parameter
          _, #paramname
          (typename |        #Foo
          VarTy[typename] |  #var Foo
          PtrTy[typename] |  #ptr Foo
          RefTy[typename]),  #ref Foo
          _],
            .._], #other params
          .._]: procs.add($name)
  result = newLit(procs)


type Bar = object
proc a*(b: Bar) = discard
func b*(b: Bar, c: int): string = discard
template c*(b: var Bar, c: float) = discard
iterator d*(b: ptr Bar):int = discard
method e*(b:ref Bar) {.base.} = discard
proc second_param*(a: int, b: Bar) = discard #will not match
proc unexported(a: Bar) = discard #will not match


template thisfile:string =
  instantiationInfo().filename
echo thisfile.listMethods(Bar)

#works for any module:
#const lib = "/path/to/nim/lib/pure/collections/tables.nim"
echo listMethods(lib,Table[A,B])
