let primesTo n =
  if n < 3 then (if n < 2 then Seq.empty else Seq.singleton 2) else
  let rec oddPrimesTo on =
    let sqrtlmt = double on |> sqrt |> truncate |> int
    let obps = if sqrtlmt < 3 then Seq.empty else oddPrimesTo sqrtlmt
    let ns = [ 3 .. 2 .. on ]
    let filtfnc fn = Seq.forall (fun bp -> bp * bp > fn ||
                                             fn % bp <> 0) obps
    Seq.filter filtfnc ns
  Seq.append  (Seq.singleton 2)  (oddPrimesTo n)

type CIS<'a> = CIS of 'a * (Unit -> CIS<'a>)

let rec skipCIS n (CIS(_, tlf) as cis) =
  if n <= 0 then cis else skipCIS (n - 1) (tlf())

let stringCIS n (CIS(fhd, ftlf)) =
  let rec addstr i (CIS(hd, tlf)) str =
    if i <= 0 then str + " )"
    else addstr (i - 1) (tlf()) (str + ", " + string hd)
  addstr (n - 1) (ftlf()) ("( " + string fhd)

type Deque<'a> = Deque of int * int * int * 'a array

let makeDQ v =
  let arr = Array.zeroCreate 1024 in arr.[0] <- v
  Deque(1023, 0, 1, arr)

let growDQ (Deque(msk, hdi, tli, arr)) =
  let sz = arr.Length
  let nsz = if sz = 0 then 1024 else sz + sz
  let narr =  Array.zeroCreate nsz
  let nhdi, ntli =
    if hdi = 0 then Array.blit arr 0 narr 0 sz
                    hdi, sz
    else let mv = hdi + sz // move top queue up...
         Array.blit arr 0 narr 0 tli
         Array.blit arr hdi narr mv (sz - hdi)
         mv, tli
  Deque(nsz - 1, nhdi, ntli, narr)

let pushDQ v (Deque(_, hdi, tli, _) as dq) =
  let (Deque(nmsk, nhdi, ntli, narr)) = if tli <> hdi then dq
                                                                   else growDQ dq
  narr.[ntli] <- v
  Deque(nmsk, nhdi, (ntli + 1) &&& nmsk, narr)

// Deque is never empty after the first push and always push before pull!
let inline peekDQ (Deque(_, hdi, _, arr)) = arr.[hdi]
let pullDQ (Deque(msk, hdi, tli, arr)) =
  Deque(msk, (hdi + 1) &&& msk, tli, arr)

let smoothsNR p =
//  if p < 2 then Seq.singleton (bigint 1) else
  let smthprms = primesTo p |> Seq.rev |> Seq.map bigint
  let frstp = Seq.head smthprms
  let rstps = Seq.tail smthprms
  let frstcis =
    let rec nxt n =
      CIS(n, fun () -> nxt (n * frstp)) in nxt frstp
  let nxt dq =
    Seq.initInfinite ((+) 1I << bigint)
  let newcis cis p =
    let rec nxt (CIS(hd, tlf) as cs) dq =
      let nxtq = peekDQ dq
      if hd < nxtq then CIS(hd, fun () -> nxt (tlf()) (pushDQ (hd * p) dq))
      else CIS(nxtq, fun () -> nxt cs (pushDQ (nxtq * p) dq |> pullDQ))
    CIS(p, fun () -> nxt cis (makeDQ (p * p)))
  CIS(1I, fun () -> Seq.fold newcis frstcis rstps)

let strt = System.DateTime.Now.Ticks

primesTo 29 |> Seq.iter (fun p ->
  printfn "First 25 %d-smooth:" p
  smoothsNR p |> stringCIS 25 |> printfn "%s\r\n")

primesTo 29 |> Seq.skip 1 |> Seq.iter (fun p ->
  printfn "The first three from the 3,000th %d-smooth numbers are:" p
  smoothsNR p |> skipCIS 2999 |> stringCIS 3 |> printfn "%s\r\n")

primesTo 521 |> Seq.skipWhile ((>) 503) |> Seq.iter (fun p ->
  printfn "The first 20 from the 30,000th up %d-smooth numbers are:" p
  smoothsNR p |> skipCIS 29999 |> stringCIS 20 |> printfn "%s\r\n")

let stop = System.DateTime.Now.Ticks
printfn "This took %d milliseconds." ((stop - strt) / 10000L)
