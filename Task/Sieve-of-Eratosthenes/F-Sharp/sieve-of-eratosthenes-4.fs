type 'a CIS = CIS of 'a * (unit -> 'a CIS) //'Co Inductive Stream for laziness

let primesBirdOdds() =
  let rec (^^) (CIS(x, xtlf) as xs) (CIS(y, ytlf) as ys) = // stream merge function
    if x < y then CIS(x, fun() -> xtlf() ^^ ys)
    elif y < x then CIS(y, fun() -> xs ^^ ytlf())
    else CIS(x, fun() -> xtlf() ^^ ytlf()) // no duplication
  let pmltpls p = let adv = p + p
                  let rec nxt c = CIS(c, fun() -> nxt (c + adv)) in nxt (p * p)
  let rec allmltps (CIS(p, ptlf)) = CIS(pmltpls p, fun() -> allmltps (ptlf()))
  let rec cmpsts (CIS(CIS(c, ctlf), amstlf)) =
    CIS(c, fun() -> ctlf() ^^ cmpsts (amstlf()))
  let rec minusat n (CIS(c, ctlf) as cs) =
    if n < c then CIS(n, fun() -> minusat (n + 2u) cs)
    else minusat (n + 2u) (ctlf())
  let rec oddprms() = CIS(3u, fun() -> oddprms() |> allmltps |> cmpsts |> minusat 5u)
  Seq.unfold (fun (CIS(p, ptlf)) -> Some(p, ptlf())) (CIS(2u, fun() -> oddprms()))
