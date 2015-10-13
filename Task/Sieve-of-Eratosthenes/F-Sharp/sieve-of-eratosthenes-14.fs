let private PGSZBTS = (1 <<< 14) * 8 // sieve buffer size in bits
type private PS = class
  val i:int val p:uint64 val cmpsts:uint32[]
  new(i,p,c) = { i=i; p=p; cmpsts=c } end
let rec primesPaged(): System.Collections.Generic.IEnumerable<_> =
  let lbpse = lazy (primesPaged().GetEnumerator()) // lazy to prevent race
  let bpa = ResizeArray() // fills from above sequence as needed
  let makePg low =
    let nxt = low + (uint64 PGSZBTS <<< 1)
    let cmpsts = Array.zeroCreate (PGSZBTS >>> 5)
    let inline notprm c = cmpsts.[c >>> 5] &&& (1u <<< c) <> 0u
    let rec nxti c = if c < PGSZBTS && notprm c
                       then nxti (c + 1) else c
    let inline mrkc c = let w = c >>> 5
                        cmpsts.[w] <- cmpsts.[w] ||| (1u <<< c)
    let rec cullf i =
      if notprm i then cullf (i + 1) else
        let p = 3 + i + i in let sqr = p * p
        if uint64 sqr < nxt then
          let rec cullp c = if c < PGSZBTS then mrkc c; cullp (c + p)
                            else cullf (i + 1) in cullp ((sqr - 3) >>> 1)
    if low <= 3UL then cullf 0 // special culling for the first page
    else // cull rest based on a secondary base prime stream
      let bpse = lbpse.Force()
      if bpa.Count <= 0 then // move past 2 to 3
        bpse.MoveNext() |> ignore; bpse.MoveNext() |> ignore
      let rec fill np =
        if np * np >= nxt then
          let bpasz = bpa.Count
          let rec cull i =
            if i < bpasz then
              let p = bpa.[i] in let sqr = p * p in let pi = int p
              let strt = if sqr >= low then int (sqr - low) >>> 1
                         else let r = int (((low - sqr) >>> 1) % p)
                              if r = 0 then 0 else int p - r
              let rec cullp c = if c < PGSZBTS then mrkc c; cullp (c + pi)
              cullp strt; cull (i + 1) in cull 0
        else bpa.Add(np); bpse.MoveNext() |> ignore
             fill bpse.Current
      fill bpse.Current // fill pba as necessary and do cull
    let ni = nxti 0 in let np = low + uint64 (ni <<< 1)
    PS(ni, np, cmpsts)
  let nmrtr() =
    let ps = ref (PS(0, 0UL, Array.zeroCreate 0))
    { new System.Collections.Generic.IEnumerator<_> with
        member this.Current = (!ps).p
      interface System.Collections.IEnumerator with
        member this.Current = box ((!ps).p)
        member this.MoveNext() =
          let drps = !ps in let i = drps.i in let p = drps.p
          let cmpsts = drps.cmpsts in let lmt = cmpsts.Length <<< 5
          if p < 3UL then (if p < 2UL then ps := PS(0, 2UL, cmpsts); true
                           else ps := makePg 3UL; true) else
          let inline notprm c = cmpsts.[c >>> 5] &&& (1u <<< c) <> 0u
          let rec nxti c = if c < lmt && notprm c
                             then nxti (c + 1) else c
          let ni = nxti (i + 1) in let np = p + uint64 ((ni - i) <<< 1)
          if ni < lmt then ps := PS(ni, np, cmpsts); true
          else ps := makePg np; true
        member this.Reset() = failwith "IEnumerator.Reset() not implemented!!!"
      interface System.IDisposable with
        member this.Dispose() = () }
  { new System.Collections.Generic.IEnumerable<_> with
      member this.GetEnumerator() = nmrtr()
    interface System.Collections.IEnumerable with
      member this.GetEnumerator() = nmrtr() :> System.Collections.IEnumerator }
