open System.Collections.Generic
open Microsoft.FSharp.NativeInterop

// a count and logarithmic approximation of the humble value...
type LogRep = struct val lg: uint64; val x2: uint16; val x3: uint16;
                                     val x5: uint16; val x7: uint16
                     new(lg, x2, x3, x5, x7) =
                       {lg = lg; x2 = x2; x3 = x3; x5 = x5; x7 = x7 } end
let one: LogRep = LogRep(0UL, 0us, 0us, 0us, 0us)
let logshft = 50
let fac = pown 2.0 logshft
let lg10_10 = 1UL <<< logshft
let lg7_10 = (uint64 << round) <| log 7.0 / log 10.0 * fac
let lg5_10 = (uint64 << round) <| log 5.0 / log 10.0 * fac
let lg3_10 = (uint64 << round) <| log 3.0 / log 10.0 * fac
let lg2_10 = lg10_10 - lg5_10
let inline mul2 (lr: LogRep): LogRep =
  LogRep(lr.lg + lg2_10, lr.x2 + 1us, lr.x3, lr.x5, lr.x7)
let inline mul3 (lr: LogRep): LogRep =
  LogRep(lr.lg + lg3_10, lr.x2, lr.x3 + 1us, lr.x5, lr.x7)
let inline mul5 (lr: LogRep): LogRep =
  LogRep(lr.lg + lg5_10, lr.x2, lr.x3, lr.x5 + 1us, lr.x7)
let inline mul7 (lr: LogRep): LogRep =
  LogRep(lr.lg + lg7_10, lr.x2, lr.x3, lr.x5, lr.x7 + 1us)
let lr2BigInt (lr: LogRep) =
  let rec xpnd n mlt rslt =
    if n <= 0us then rslt
    else xpnd (n - 1us) mlt (mlt * rslt)
  xpnd lr.x2 2I 1I |> xpnd lr.x3 3I |> xpnd lr.x5 5I |> xpnd lr.x7 7I

type CIS<'a> = CIS of 'a * (Unit -> CIS<'a>) // infinite Co-Inductive Stream...
let cis2Seq cis =
  Seq.unfold (fun (CIS(hd, tlf)) -> Some(hd, tlf())) cis

let humblesLog() =
  let prmfs = [ mul7; mul5; mul3; mul2 ]
  let frstpf = Seq.head prmfs
  let rstpfs = Seq.tail prmfs
  let frstll =
    let rec nxt n = CIS(n, fun () -> nxt (frstpf n))
    nxt (frstpf one)
  let mkcis cis mf =
    let q = Queue<LogRep>(1024)
    let fv = mf one
    let nv = mf fv
    let rec nxt (hdv: LogRep) (CIS(chd: LogRep, ctlf) as cis) =
      if hdv.lg < chd.lg then
        CIS(hdv, fun () -> q.Enqueue (mf hdv); nxt (q.Dequeue()) cis)
      else CIS(chd, fun () -> q.Enqueue (mf chd); nxt hdv (ctlf()))
    CIS(fv, fun () -> nxt nv cis)
  CIS(one, fun () -> (Seq.fold mkcis frstll rstpfs))

let comma3 v =
  let s = string v
  let rec loop n lst =
    if n < 1 then List.fold (fun s xs ->
      s + "," + xs) (List.head lst) <| List.tail lst
    else let nn = max (n - 3) 0 in loop nn (s.[nn .. n - 1] :: lst)
  loop (String.length s) []

printfn "The first 50 humble numbers are:"
humblesLog() |> cis2Seq |> Seq.take 50 |> Seq.map lr2BigInt
|> Seq.iter (printf "%A ");printfn ""
printfn ""

let numDigits = 877
printfn "Count of humble numbers for each digit length 1-%d:" numDigits
printfn "Digits       Count              Accum"
let strt = System.DateTime.Now.Ticks
let bins = Array.zeroCreate numDigits
#nowarn "9" // no warnings for the use of native pointers...
#nowarn "51"
let lmt = uint64 numDigits <<< logshft
let rec loopw w =
  if w < lmt then
    let rec loopx x =
      if x < lmt then
        let rec loopy y =
          if y < lmt then
            let rec loopz z =
              if z < lmt then
//                let ndx = z >>> logshft |> int
//                bins.[ndx] <- bins.[ndx] + 1UL
                // use pointers to save array bounds checking...
                let ndx = &&bins.[z >>> logshft |> int]
                NativePtr.write ndx (NativePtr.read ndx + 1UL)
                loopz (z + lg7_10) in loopz y; loopy (y + lg5_10)
        loopy x; loopx (x + lg3_10) in loopx w; loopw (w + lg2_10) in loopw 0UL
bins |> Seq.scan (fun (i, _, a) v ->
  i + 1, v, a + v) (0, 0UL, 0UL) |> Seq.skip 1
|> Seq.iter (fun (i, c, a) -> printfn "%4d%14s%19s" i (comma3 c) (comma3 a))
let stop = System.DateTime.Now.Ticks
printfn "Counting took %d milliseconds" <| ((stop - strt) / 10000L)
