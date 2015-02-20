type CIS<'T> = struct val v:'T val cont:unit->CIS<'T> //Co Inductive Stream for laziness
                      new (v,cont) = { v = v; cont = cont } end
let primes =
  let rec pculls p cull = CIS(cull, fun() -> pculls p (cull + p))
  let rec allculls (ps:CIS<_>) = //stream of streams of composite culls
    CIS(pculls ps.v (ps.v * ps.v),fun() -> allculls (ps.cont()))
  let rec (^^) (xs:CIS<uint32>) (ys:CIS<uint32>) = //union op for CIS<uint32>'s
    match compare xs.v ys.v with
      | -1 -> CIS(xs.v, fun() -> xs.cont() ^^ ys) // <
      | 0 -> CIS(xs.v, fun() -> xs.cont() ^^ ys.cont()) // ==
      | _ -> CIS(ys.v, fun() -> xs ^^ ys.cont()) //must be > (= 1)
  let rec join (cmpsts:CIS<CIS<_>>) =
    CIS(cmpsts.v.v, fun() -> cmpsts.v.cont() ^^ join (cmpsts.cont()))
  let rec mkPrms cnd (cmpsts:CIS<_>) =
    let ncnd = cnd + 1u
    if cnd >= cmpsts.v then mkPrms ncnd (cmpsts.cont()) //implements 'minus'
    else CIS(cnd,fun()->mkPrms ncnd cmpsts) //found a prime
  let rec basePrimes = CIS(2u, fun() -> mkPrms 3u initCmpsts)
  and initCmpsts = join (allculls (basePrimes))
  let genseq cis = Seq.unfold (fun (cs:CIS<_>) -> Some(cs.v, cs.cont())) cis
  genseq (mkPrms 2u initCmpsts)
