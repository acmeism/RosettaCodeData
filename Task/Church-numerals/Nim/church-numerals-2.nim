import sugar

type # use a thunk closure as a data type...
  In = () -> int # a lazy thunk producing an int
  Func = In -> In
  Church = Func -> Func
  MetaChurch = Church -> Church
  MetaMetaChurch = MetaChurch -> MetaChurch
  PredChurch = (Func -> In) -> (Func -> In)
  MetaPredChurch = PredChurch -> PredChurch

type # type Kind to/from conversions...
  Pun {.union.} = object # does safer casting...
    normal: Church
    upone: MetaChurch
    uptwo: MetaMetaChurch
    preded: MetaPredChurch
func lift1(ch: Church): MetaChurch = Pun(normal: ch).upone
func lift2(ch: Church): MetaMetaChurch = Pun(normal: ch).uptwo
func liftpred(ch: Church): MetaPredChurch = Pun(normal: ch).preded

let
  zeroChurch: Church = (_: Func) -> Func => ((x: In) => x)
  oneChurch: Church = (f: Func) -> Func => f
  succChurch = (ch: Church) -> Church =>
    ((f: Func) => ((x: In) => f(ch(f)x)))
  addChurch = (ach, bch: Church) -> Church =>
    ((f: Func) => ((x: In) => ((ach f)(bch(f)x))))
  multChurch = (ach, bch: Church) -> Church => ((f: Func) => ach(bch(f)))
  expChurch = (basech, expch: Church) -> Church => (expch.lift1() basech)
  isZeroChurch = (ch: Church) -> Church =>
    (ch.lift2()((_: Church) => zeroChurch) oneChurch)
  predChurch = (ch: Church) -> Church =>
    (func(f: Func): Func =
      let prd = (gf: Func -> In) => ((hf: In -> In) => (hf(gf(f))))
      # magic is here, reduces by one function level...
      ((x: In) => (ch.liftpred())(prd)((_: Func) => x)((t:In) => t)))
  minusChurch = (ach, bch: Church) -> Church =>
     (bch.lift2()(predChurch)(ach))
  # recursively counts times divisor can be subtracted from dividend...
  divChurch = proc(dvdndch, dvsrch: Church): Church =
    proc divr(n: Church): Church =
      (((vch: Church) =>
        vch.lift2()( # test for zero
          (_: Church) => (divr(vch).succChurch))( # not zero, loop
          zeroChurch)) # if zero, return zero
      )(n.minusChurch(dvsrch)) # subtract one more divisor per loop
    divr(dvdndch.succChurch)

# conversions to/from Church and int...
proc toChurch(x: int): Church =
  result = zeroChurch
  for _ in 1 .. x: result = result.succChurch
let incr = (x: In) => (() => x() + 1)
proc toInt(ch: Church): int = ch(incr)(() => 0)()
proc `$`(ch: Church): string = $(ch.toInt)

when isMainModule:
  let threeChurch = 3.toChurch
  let fourChurch = threeChurch.succChurch
  let elevenChurch = 11.toChurch
  let twelveChurch = elevenChurch.succChurch
  echo [ threeChurch.addChurch(fourChurch)
       , threeChurch.multChurch(fourChurch)
       , threeChurch.expChurch(fourChurch)
       , fourChurch.expChurch(threeChurch)
       , zeroChurch.isZeroChurch, oneChurch.isZeroChurch
       , fourChurch.predChurch
       , elevenChurch.minusChurch(threeChurch)
       , elevenChurch.divChurch(threeChurch)
       , twelveChurch.divChurch(threeChurch)
       ]
