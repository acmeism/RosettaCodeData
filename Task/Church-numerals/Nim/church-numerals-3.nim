import sugar

type
  Tag = enum tgChurch, tgArityZero
  Church = ref object
    case tag: Tag
    of tgChurch: church: Church -> Church
    of tgArityZero: value: int
func makeCChurch(chf: Church -> Church): Church =
  Church(tag: tgChurch, church: chf)
proc applyChurch(ch, charg: Church): Church =
  case ch.tag
  of tgChurch: ch.church(charg)
  of tgArityZero: charg # never happens!
func composeChurch(chl, chr: Church): Church =
  case chl.tag
  of tgChurch:
    case chr.tag
    of tgChurch: makeCChurch((f: Church) => chl.church(chr.church(f)))
    of tgArityZero: chl # never happens!
  of tgArityZero: chl # never happens!

let churchZero = makeCChurch((f: Church) => makeCChurch((x) => x))
let churchOne = makeCChurch((x) => x)
proc succChurch(ch: Church): Church =
  makeCChurch((f) => composeChurch(f, applyChurch(ch, f)))
proc addChurch(cha, chb: Church): Church =
  makeCChurch((f) =>
    composeChurch(applyChurch(cha, f), applyChurch(chb, f)))
proc multChurch(cha, chb: Church): Church = composeChurch(cha, chb)
proc expChurch(chbs, chexp: Church): Church = applyChurch(chexp, chbs)
proc isZeroChurch(ch: Church): Church =
  applyChurch(applyChurch(ch, Church(tag: tgChurch,
                                     church: (_: Church) => churchZero)),
              churchOne)
proc predChurch(ch: Church): Church =
  proc ff(f: Church): Church =
    proc xf(x: Church): Church =
      let prd = makeCChurch((g) => makeCChurch((h) =>
                  applyChurch(h, applyChurch(g, f))))
      let frstch = makeCChurch((_) => x)
      let idch = makeCChurch((a) => a)
      applyChurch(applyChurch(applyChurch(ch, prd), frstch), idch)
    makeCChurch(xf)
  makeCChurch(ff)
proc subChurch(cha, chb: Church): Church =
  applyChurch(applyChurch(chb, makeCChurch(predChurch)), cha)
proc divChurch(chdvdnd, chdvsr: Church): Church =
  proc divr(chn: Church): Church =
    proc tst(chv: Church): Church =
      let loopr = makeCChurch((_) => succChurch(divr(chv)))
      applyChurch(applyChurch(chv, loopr), churchZero)
    tst(subChurch(chn, chdvsr))
  divr(succChurch(chdvdnd))

# converters...
converter intToChurch(i: int): Church =
  func loop(n: int, rch: Church): Church = # recursive function call
    if n <= 0: rch else: loop(n - 1, succChurch(rch))
  loop(i, churchZero)
#  result = churchZero # imperative non recursive way...
#  for _ in 1 .. i: result = succChurch(result)
converter churchToInt(ch: Church): int =
  func succInt(chv: Church): Church =
    case chv.tag
    of tgArityZero: Church(tag: tgArityZero, value: chv.value + 1)
    of tgChurch: chv
  let rslt = applyChurch(applyChurch(ch, Church(tag: tgChurch, church: succInt)),
                         Church(tag: tgArityZero, value: 0))
  case rslt.tag
  of tgArityZero: rslt.value
  of tgChurch: -1
proc `$`(ch: Church): string = $ch.int

# test it...
when isMainModule:
  let c3: Church = 3
  let c4 = succChurch c3
  let c11: Church = 11
  let c12 = succChurch c11
  echo addChurch(c3, c4), " ",
       multChurch(c3, c4), " ",
       expChurch(c3, c4), " ",
       expChurch(c4, c3), " ",
       isZeroChurch(churchZero), " ",
       isZeroChurch(c3), " ",
       predChurch(c4), " ",
       subChurch(c11, c3), " ",
       divChurch(c11, c3), " ",
       divChurch(c12, c3)
