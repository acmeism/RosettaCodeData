import macros, sugar
type
  Fn = proc(p: pointer): pointer{.noSideEffect.}
  Church = proc(f: Fn): Fn{.noSideEffect.}
  MetaChurch = proc(c: Church): Church{.noSideEffect.}

#helpers:
template λfλx(exp): untyped = (f: Fn){.closure.}=>((x: pointer){.closure.}=>exp)
template λcλf(exp): untyped = (c: Church){.closure.}=>((f: Fn){.closure.}=>exp)
macro type_erase(body: untyped): untyped =
  let
    name = if body[0].kind == nnkPostFix: body[0][1] else: body[0]
    typ = body[3][0]
  quote do:
    `body`
    proc `name`(p: pointer): pointer =
      template erased: untyped = cast[ptr `typ`](p)[]
      erased = erased.`name`
      p
macro type_erased(body: untyped): untyped =
  let (id1, id2, id3) = (body[0][0][0], body[0][0][1], body[0][1])
  quote do:
    result = `id3`
    result = cast[ptr typeof(`id3`)](
      `id1`(`id2`)(result.addr)
      )[]

#simple math
func zero*(): Church = λfλx: x
func succ*(c: Church): Church = λfλx: f (c f)x
func `+`*(c, d: Church): Church = λfλx: (c f) (d f)x
func `*`*(c, d: Church): Church = λfλx: c(d f)x

#exponentiation
func metazero(): MetaChurch = λcλf: f
func succ(m: MetaChurch): MetaChurch{.type_erase.} = λcλf: c (m c)f
converter toMeta*(c: Church): MetaChurch = type_erased: c(succ)(metazero())
func `^`*(c: Church, d: MetaChurch): Church = d c

#conversions to/from actual numbers
func incr(x: int): int{.type_erase.} = x+1
func toInt(c: Church): int = type_erased: c(incr)(0)
func toChurch*(x: int): Church = return if x <= 0: zero() else: toChurch(x-1).succ
func `$`*(c: Church): string = $c.toInt

when isMainModule:
  let three = zero().succ.succ.succ
  let four = 4.toChurch
  echo [three+four, three*four, three^four, four^three]
