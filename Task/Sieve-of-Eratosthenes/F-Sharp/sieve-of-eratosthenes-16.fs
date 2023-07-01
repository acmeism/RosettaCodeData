type Prime = float // use uint64/int64 for regular 64-bit F#
type private PrimeNdx = float // they are slow in JavaScript polyfills

let inline private prime n = float n // match these convenience conversions
let inline private primendx n = float n // with the types above!

let private cPGSZBTS = (1 <<< 14) * 8 // sieve buffer size in bits = CPUL1CACHE

type private SieveBuffer = uint8[]

/// a Co-Inductive Stream (CIS) of an "infinite" non-memoized series...
type private CIS<'T> = CIS of 'T * (unit -> CIS<'T>) //' apostrophe formatting adjustment

/// lazy list (memoized) series of base prime page arrays...
type private BasePrime = uint32
type private BasePrimeArr = BasePrime[]
type private BasePrimeArrs = BasePrimeArrs of BasePrimeArr * Option<Lazy<BasePrimeArrs>>

/// Masking array is faster than bit twiddle bit shifts!
let private cBITMASK = [| 1uy; 2uy; 4uy; 8uy; 16uy; 32uy; 64uy; 128uy |]

let private cullSieveBuffer lwi (bpas: BasePrimeArrs) (sb: SieveBuffer) =
  let btlmt = (sb.Length <<< 3) - 1 in let lmti = lwi + primendx btlmt
  let rec loopbp (BasePrimeArrs(bpa, bpatl) as ibpas) i =
    if i >= bpa.Length then
      match bpatl with
      | None -> ()
      | Some lv -> loopbp lv.Value 0 else
    let bp = prime bpa.[i] in let bpndx = primendx ((bp - prime 3) / prime 2)
    let s = (bpndx * primendx 2) * (bpndx + primendx 3) + primendx 3 in let bpint = int bp
    if s <= lmti then
      let s0 = // page cull start address calculation...
        if s >= lwi then int (s - lwi) else
        let r = (lwi - s) % (primendx bp)
        if r = primendx 0 then 0 else int (bp - prime r)
      let slmt = min btlmt (s0 - 1 + (bpint <<< 3))
      let rec loopc c = // loop "unpeeling" is used so
        if c <= slmt then // a constant mask can be used over the inner loop
          let msk = cBITMASK.[c &&& 7]
          let rec loopw w =
            if w < sb.Length then sb.[w] <- sb.[w] ||| msk; loopw (w + bpint)
          loopw (c >>> 3); loopc (c + bpint)
      loopc s0; loopbp ibpas (i + 1) in loopbp bpas 0

/// fast Counting Look Up Table (CLUT) for pop counting...
let private cCLUT =
  let arr = Array.zeroCreate 65536
  let rec popcnt n cnt = if n > 0 then popcnt (n &&& (n - 1)) (cnt + 1) else uint8 cnt
  let rec loop i = if i < 65536 then arr.[i] <- popcnt i 0; loop (i + 1)
  loop 0; arr

let countSieveBuffer ndxlmt (sb: SieveBuffer): int =
  let lstw = (ndxlmt >>> 3) &&& -2
  let msk = (-2 <<< (ndxlmt &&& 15)) &&& 0xFFFF
  let inline cntem i m =
    int cCLUT.[int (((uint32 sb.[i + 1]) <<< 8) + uint32 sb.[i]) ||| m]
  let rec loop i cnt =
    if i >= lstw then cnt - cntem lstw msk else loop (i + 2) (cnt - cntem i 0)
  loop 0 ((lstw <<< 3) + 16)

/// a CIS series of pages from the given start index with the given SieveBuffer size,
/// and provided with a polymorphic converter function to produce
/// and type of result from the culled page parameters...
let rec private makePrimePages strtwi btsz
                               (cnvrtrf: PrimeNdx -> SieveBuffer -> 'T): CIS<'T> =
  let bpas = makeBasePrimes() in let sb = Array.zeroCreate (btsz >>> 3)
  let rec nxtpg lwi =
    Array.fill sb 0 sb.Length 0uy; cullSieveBuffer lwi bpas sb
    CIS(cnvrtrf lwi sb, fun() -> nxtpg (lwi + primendx btsz))
  nxtpg strtwi

/// secondary feed of lazy list of memoized pages of base primes...
and private makeBasePrimes(): BasePrimeArrs =
  let sb2bpa lwi (sb: SieveBuffer) =
    let bsbp = uint32 (primendx 3 + lwi + lwi)
    let arr = Array.zeroCreate <| countSieveBuffer 255 sb
    let rec loop i j =
      if i < 256 then
        if sb.[i >>> 3] &&& cBITMASK.[i &&& 7] <> 0uy then loop (i + 1) j
        else arr.[j] <- bsbp + uint32 (i + i); loop (i + 1) (j + 1)
    loop 0 0; arr
  // finding the first page as not part of the loop and making succeeding
  // pages lazy breaks the recursive data race!
  let frstsb = Array.zeroCreate 32
  let fkbpas = BasePrimeArrs(sb2bpa (primendx 0) frstsb, None)
  cullSieveBuffer (primendx 0) fkbpas frstsb
  let rec nxtbpas (CIS(bpa, tlf)) = BasePrimeArrs(bpa, Some(lazy (nxtbpas (tlf()))))
  BasePrimeArrs(sb2bpa (primendx 0) frstsb,
                Some(lazy (nxtbpas <| makePrimePages (primendx 256) 256 sb2bpa)))

/// produces a generator of primes; uses mutability for better speed...
let primes(): unit -> Prime =
  let sb2prms lwi (sb: SieveBuffer) = lwi, sb in let mutable ndx = -1
  let (CIS((nlwi, nsb), npgtlf)) = // use page generator function above!
    makePrimePages (primendx 0) cPGSZBTS sb2prms
  let mutable lwi = nlwi in let mutable sb = nsb
  let mutable pgtlf = npgtlf
  let mutable baseprm = prime 3 + prime (lwi + lwi)
  fun() ->
    if ndx < 0 then ndx <- 0; prime 2 else
    let inline notprm i = sb.[i >>> 3] &&& cBITMASK.[i &&& 7] <> 0uy
    while ndx < cPGSZBTS && notprm ndx do ndx <- ndx + 1
    if ndx >= cPGSZBTS then // get next page if over
      let (CIS((nlwi, nsb), npgtlf)) = pgtlf() in ndx <- 0
      lwi <- nlwi; sb <- nsb; pgtlf <- npgtlf
      baseprm <- prime 3 + prime (lwi + lwi)
      while notprm ndx do ndx <- ndx + 1
    let ni = ndx in ndx <- ndx + 1 // ready for next call!
    baseprm + prime (ni + ni)

let countPrimesTo (limit: Prime): int = // much faster!
  if limit < prime 3 then (if limit < prime 2 then 0 else 1) else
  let topndx = (limit - prime 3) / prime 2 |> primendx
  let sb2cnt lwi (sb: SieveBuffer) =
    let btlmt = (sb.Length <<< 3) - 1 in let lmti = lwi + primendx btlmt
    countSieveBuffer
      (if lmti < topndx then btlmt else int (topndx - lwi)) sb, lmti
  let rec loop (CIS((cnt, nxti), tlf)) count =
    if nxti < topndx then loop (tlf()) (count + cnt)
    else count + cnt
  loop <| makePrimePages (primendx 0) cPGSZBTS sb2cnt <| 1

/// sequences are convenient but slow...
let primesSeq() = primes() |> Seq.unfold (fun gen -> Some(gen(), gen))
printfn "The first 25 primes are:  %s"
  ( primesSeq() |> Seq.take 25
      |> Seq.fold (fun s p -> s + string p + " ") "" )
printfn "There are %d primes up to a million."
  ( primesSeq() |> Seq.takeWhile ((>=) (prime 1000000)) |> Seq.length )

let rec cntto gen lmt cnt = // faster than seq's but still slow
  if gen() > lmt then cnt else cntto gen lmt (cnt + 1)

let limit = prime 1_000_000_000
let start = System.DateTime.Now.Ticks
// let answr = cntto (primes()) limit 0 // slower way!
let answr = countPrimesTo limit // over twice as fast way!
let elpsd = (System.DateTime.Now.Ticks - start) / 10000L
printfn "Found %d primes to %A in %d milliseconds." answr limit elpsd
