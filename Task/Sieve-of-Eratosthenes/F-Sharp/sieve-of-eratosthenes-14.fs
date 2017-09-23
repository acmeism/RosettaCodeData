type Prime = uint32
let frstprm = 2u
let frstoddprm = 3u
let inc = 2u
let primesDict() =
  let dct = System.Collections.Generic.Dictionary()
  let rec nxtprm n q (bps: CIS<Prime>) =
    if n >= q then let bp = bps.v in let adv = bp + bp
                   let nbps = bps.cont() in let nbp = nbps.v
                   dct.Add(n + adv, adv)
                   nxtprm (n + inc) (nbp * nbp) nbps
    else if dct.ContainsKey(n) then
           let adv = dct.[n]
           dct.Remove(n) |> ignore
//           let mutable nn = n + adv // ugly imperative code
//           while dct.ContainsKey(nn) do nn <- nn + adv
//           dct.Add(nn, adv)
           let rec nxtmt k = // advance to next empty spot
             if dct.ContainsKey(k) then nxtmt (k + adv)
             else dct.Add(k, adv) in nxtmt (n + adv)
           nxtprm (n + inc) q bps
         else CIS(n, fun() -> nxtprm (n + inc) q bps)
  let rec oddprms() = CIS(frstoddprm, fun() ->
      nxtprm (frstoddprm + inc) (frstoddprm * frstoddprm) (oddprms()))
  Seq.unfold (fun (cis: CIS<Prime>) -> Some(cis.v, cis.cont()))
             (CIS(frstprm, fun() -> (oddprms())))
