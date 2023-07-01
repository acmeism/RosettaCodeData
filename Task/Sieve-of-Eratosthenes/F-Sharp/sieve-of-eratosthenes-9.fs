let primesPQx() =
  let rec nxtprm n pq q (bps: CIS<Prime>) =
    if n >= q then let bp = bps.v in let adv = bp + bp
                   let nbps = bps.cont() in let nbp = nbps.v
                   nxtprm (n + inc) (MinHeap.push (n + adv) adv pq) (nbp * nbp) nbps
    else let ck, cv = match MinHeap.peekMin pq with
                        | None -> (q, inc) // only happens until first insertion
                        | Some kv -> kv
         if n >= ck then let rec adjpq ck cv pq =
                             let npq = MinHeap.replaceMin (ck + cv) cv pq
                             match MinHeap.peekMin npq with
                               | None -> npq // never happens
                               | Some(nk, nv) -> if n >= nk then adjpq nk nv npq
                                                 else npq
                         nxtprm (n + inc) (adjpq ck cv pq) q bps
         else CIS(n, fun() -> nxtprm (n + inc) pq q bps)
  let rec oddprms() = CIS(frstoddprm, fun() ->
      nxtprm (frstoddprm + inc) MinHeap.empty (frstoddprm * frstoddprm) (oddprms()))
  Seq.unfold (fun (cis: CIS<Prime>) -> Some(cis.v, cis.cont()))
             (CIS(frstprm, fun() -> (oddprms())))
