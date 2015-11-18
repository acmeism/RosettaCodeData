type CIS<'T> = struct val v:'T val cont:unit->CIS<'T> //'Co Inductive Stream for laziness
                      new (v,cont) = { v = v; cont = cont } end
type Primes = uint32

let primesBird() =
  let rec (^^) (xs: CIS<Prime>) (ys: CIS<Prime>) = // stream merge function
    let x = xs.v in let y = ys.v
    if x < y then CIS(x, fun() -> xs.cont() ^^ ys)
    elif y < x then CIS(y, fun() -> xs ^^ ys.cont())
    else CIS(x, fun() -> xs.cont() ^^ ys.cont()) // no duplications
  let pmltpls p = let rec nxt c = CIS(c, fun() -> nxt (c + p)) in nxt (p * p)
  let rec allmltps (ps: CIS<Prime>) = CIS(pmltpls ps.v, fun() -> allmltps (ps.cont()))
  let rec cmpsts (css: CIS<CIS<Prime>>) =
    CIS(css.v.v, fun() -> (css.v.cont()) ^^ (cmpsts (css.cont())))
  let rec minusat n (cs: CIS<Prime>) =
    if n < cs.v then CIS(n, fun() -> minusat (n + 1u) cs)
    else minusat (n + 1u) (cs.cont())
  let rec baseprms() = CIS(2u, fun() -> minusat 3u (cmpsts (allmltps (baseprms()))))
  Seq.unfold (fun (ps: CIS<Prime>) -> Some(ps.v, ps.cont()))
             (minusat 2u (cmpsts (allmltps (baseprms()))))
