type CIS<'T> = struct val v: 'T val cont: unit -> CIS<'T> new(v,cont) = {v=v;cont=cont} end
type Prime = uint64
let frstprm = 2UL
let frstoddprm = 3UL
let inc = 2UL

let primesPQ() =
  let pmult p (xs: CIS<Prime>) = // does map (* p) xs
    let rec nxtm (cs: CIS<Prime>) =
      CIS(p * cs.v, fun() -> nxtm (cs.cont())) in nxtm xs
  let insertprime p xs table =
    MinHeap.push (p * p) (pmult p xs) table
  let rec sieve' (ns: CIS<Prime>) table =
    let nextcomposite = match MinHeap.peekMin table with
                          | None -> ns.v // never happens
                          | Some (k, _) -> k
    let rec adjust table =
      let (n, advs) = match MinHeap.peekMin table with
                        | None -> (ns.v, ns.cont()) // never happens
                        | Some kv -> kv
      if n <= ns.v then adjust (MinHeap.replaceMin advs.v (advs.cont()) table)
      else table
    if nextcomposite <= ns.v then sieve' (ns.cont()) (adjust table)
    else let n = ns.v in CIS(n, fun() ->
           let nxtns = ns.cont() in sieve' nxtns (insertprime n nxtns table))
  let rec sieve (ns: CIS<Prime>) = let n = ns.v in CIS(n, fun() ->
      let nxtns = ns.cont() in sieve' nxtns (insertprime n nxtns MinHeap.empty))
  let odds = // is the odds CIS from 3 up
    let rec nxto i = CIS(i, fun() -> nxto (i + inc)) in nxto frstoddprm
  Seq.unfold (fun (cis: CIS<Prime>) -> Some(cis.v, cis.cont()))
             (CIS(frstprm, fun() -> (sieve odds)))
