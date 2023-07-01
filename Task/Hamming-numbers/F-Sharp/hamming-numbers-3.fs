let cCOUNT = 1000000

type LogRep = struct val lr: double; val x2: uint32; val x3: uint32; val x5: uint32
                     new(lr, x2, x3, x5) = {lr = lr; x2 = x2; x3 = x3; x5 = x5 } end
let one: LogRep = LogRep(0.0, 0u, 0u, 0u)
let lg2_2: double = 1.0
let lg3_2: double = log 3.0 / log 2.0
let lg5_2: double = log 5.0 / log 2.0
let inline mul2 (lr: LogRep): LogRep = LogRep(lr.lr + lg2_2, lr.x2 + 1u, lr.x3, lr.x5)
let inline mul3 (lr: LogRep): LogRep = LogRep(lr.lr + lg3_2, lr.x2, lr.x3 + 1u, lr.x5)
let inline mul5 (lr: LogRep): LogRep = LogRep(lr.lr + lg5_2, lr.x2, lr.x3, lr.x5 + 1u)

let hammingsLog() = // imperative arrays, eliminates the BigInteger operations...
  let s2 = ResizeArray<_>() in let s3 = ResizeArray<_>()
  s2.Add(one); s3.Add(mul3 one)
  let mutable s5 = mul5 one in let mutable mrg = mul3 one
  let mutable s2hdi = 0 in let mutable s3hdi = 0
  let next() = // imperative next function to advance value
    if s2hdi + s2hdi >= s2.Count then s2.RemoveRange(0, s2hdi); s2hdi <- 0
    let mutable rslt: LogRep = s2.[s2hdi]
    if rslt.lr < mrg.lr then s2.Add(mul2 rslt); s2hdi <- s2hdi + 1
    else
      if s3hdi + s3hdi >= s3.Count then s3.RemoveRange(0, s3hdi); s3hdi <- 0
      rslt <- mrg; s2.Add(mul2 rslt); s3.Add(mul3 rslt); s3hdi <- s3hdi + 1
      let chkv: LogRep = s3.[s3hdi]
      if chkv.lr < s5.lr then  mrg <- chkv
      else mrg <- s5; s5 <- mul5 s5; s3hdi <- s3hdi - 1
    rslt
  next

let hl2Seq f = Seq.unfold (fun v -> Some(v, f())) (f())
let nthLogHamming n f =
  let rec nxt i = if i >= n then f() else f() |> ignore; nxt (i + 1) in nxt 0

let lr2BigInt (lr: LogRep) = // convert trival to BigInteger
  let rec xpnd n mlt rslt =
    if n <= 0u then rslt
    else xpnd (n - 1u) mlt (mlt * rslt)
  xpnd lr.x2 2I 1I |> xpnd lr.x3 3I |> xpnd lr.x5 5I

[<EntryPoint>]
let main argv =
  printf "( "; hammingsLog() |> hl2Seq |> Seq.take 20
            |> Seq.iter (printf "%A " << lr2BigInt); printfn ")"
  printfn "%A" (hammingsLog() |> hl2Seq |> Seq.item (1691 - 1) |> lr2BigInt)
  let strt = System.DateTime.Now.Ticks
// slow way using Seq:
//  let rslt = (hammingsLog()) |> hl2Seq |> Seq.item (1000000 - 1)
// fast way using closure directly:
  let rslt = (hammingsLog()) |> nthLogHamming (1000000 - 1)

  let stop = System.DateTime.Now.Ticks

  printfn "%A" (rslt |> lr2BigInt)
  printfn "Found this last up to %d in %d milliseconds." cCOUNT ((stop - strt) / 10000L)

  printfn ""
  0 // return an integer exit code
