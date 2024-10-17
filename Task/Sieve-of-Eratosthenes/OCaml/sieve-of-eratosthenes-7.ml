let cLIMIT = 1_000_000

type 'a cis = CIS of 'a * (unit -> 'a cis)

let primesTF() =
  let rec merge (CIS(x, xtl) as xs) (CIS(y, ytl) as ys) =
    if x < y then CIS(x, fun() -> merge (xtl()) ys)
    else if y < x then  CIS(y, fun() -> merge xs (ytl()))
    else  CIS(x, fun() -> merge (xtl()) (ytl()))
  in let bpmults bp =
       let adv = bp + bp in
       let rec pmlt vr = CIS(vr, fun() -> pmlt (vr + adv))
       in pmlt (bp * bp)
  in let rec allmlts = function
       | CIS(bp, bptf) -> CIS(bpmults bp, fun() -> allmlts (bptf()))
  in let rec pairs = function
       | CIS(mcs, cstf) ->
         let CIS(nmcs, ncstf) = cstf() in
         CIS(merge mcs nmcs, fun() -> pairs (ncstf()))
  in let rec cmpsts = function
       | CIS(CIS(cr, ctfr), cstf) ->
           CIS(cr, fun() -> merge (ctfr()) (cstf() |> pairs |> cmpsts))
  in let rec testAt n csr =
       match csr with
         | CIS(cr, ctlr) ->
             if n >= cr then testAt (n + 2) (ctlr())
             else CIS(n, fun() -> testAt (n + 2) csr)
  in let rec oddprms() = CIS(3, fun() -> oddprms() |> allmlts |> cmpsts |> testAt 5)
  in CIS(2, fun() -> oddprms())

let showprmsTo lmt pcis =
  let rec loop lst = function
    | CIS(p, ptf) -> if p > lmt then List.rev lst |> List.map string_of_int
                                       |> String.concat "; "|> print_endline
                     else loop (p :: lst) (ptf())
  in loop [] pcis

let countprmsTo lmt pcis =
  let rec loop cnt = function
    | CIS(p, ptf) -> if p > lmt then cnt else loop (cnt + 1) (ptf())
  in loop 0 pcis

let _ = showprmsTo 100 (primesTF())
let strt = Sys.time()
let answr = countprmsTo cLIMIT (primesTF())
let elpsd = (Sys.time() -. strt) *. 1000.
let _ = Printf.printf "Found %d primes to %d in %f milliseconds.\r\n" answr cLIMIT elpsd
