type CIS<'T> = struct val v:'T val cont:unit->CIS<'T> //'Co Inductive Stream for laziness
                      new (v,cont) = { v = v; cont = cont } end
type Prime = uint32

let primesTreeFold() =
  let rec (^^) (xs: CIS<Prime>) (ys: CIS<Prime>) = // merge streams; no duplicates
    let x = xs.v in let y = ys.v
    if x < y then CIS(x, fun() -> xs.cont() ^^ ys)
    elif y < x then CIS(y, fun() -> xs ^^ ys.cont())
    else CIS(x, fun() -> xs.cont() ^^ ys.cont())
  let pmltpls p = let adv = p + p
                  let rec nxt c = CIS(c, fun() -> nxt (c + adv)) in nxt (p * p)
  let rec allmltps (ps: CIS<Prime>) = CIS(pmltpls ps.v, fun() -> allmltps (ps.cont()))
  let rec pairs (css: CIS<CIS<Prime>>) =
    let ncss = css.cont()
    CIS(css.v ^^ ncss.v, fun() -> pairs (ncss.cont()))
  let rec cmpsts (css: CIS<CIS<Prime>>) =
    CIS(css.v.v, fun() -> (css.v.cont()) ^^ (cmpsts << pairs << css.cont)())
  let rec minusat n (cs: CIS<Prime>) =
    if n < cs.v then CIS(n, fun() -> minusat (n + 2u) cs)
    else minusat (n + 2u) (cs.cont())
  let rec oddprms() = CIS(3u, fun() -> (minusat 5u << cmpsts << allmltps) (oddprms()))
  Seq.unfold (fun (ps: CIS<Prime>) -> Some(ps.v, ps.cont()))
             (CIS(2u, fun() -> (minusat 3u << cmpsts << allmltps) (oddprms())))
