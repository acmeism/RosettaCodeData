open System.Threading

type Buckets(n) =
  let rand = System.Random()
  let mutex = Array.init n (fun _ -> new Mutex())
  let bucket = Array.init n (fun _ -> 100)

  member this.Count = n

  member this.Item n = bucket.[n]

  member private this.Lock is k =
    let is = Seq.sort is
    for i in is do
      mutex.[i].WaitOne() |> ignore
    try k() finally
    for i in is do
      mutex.[i].ReleaseMutex()

  member this.Transfer i j d =
    if i <> j && d <> 0 then
      let i, j, d = if d > 0 then i, j, d else j, i, -d
      this.Lock [i; j] (fun () ->
        let d = min d bucket.[i]
        bucket.[i] <- bucket.[i] - d
        bucket.[j] <- bucket.[j] + d)

  member this.Read =
    this.Lock [0..n-1] (fun () -> Array.copy bucket)

  member this.Print() =
    let xs = this.Read
    printf "%A = %d\n" xs (Seq.sum xs)

  interface System.IDisposable with
    member this.Dispose() =
      for m in mutex do
        (m :> System.IDisposable).Dispose()

let transfers = ref 0
let max_transfers = 1000000

let rand_pair (rand: System.Random) n =
  let i, j = rand.Next n, rand.Next(n-1)
  i, if j<i then j else j+1

let equalizer (bucket: Buckets) () =
  let rand = System.Random()
  while System.Threading.Interlocked.Increment transfers < max_transfers do
    let i, j = rand_pair rand bucket.Count
    let d = (bucket.[i] - bucket.[j]) / 2
    if d > 0 then
      bucket.Transfer i j d
    else
      bucket.Transfer j i -d

let randomizer (bucket: Buckets) () =
  let rand = System.Random()
  while System.Threading.Interlocked.Increment transfers < max_transfers do
    let i, j = rand_pair rand bucket.Count
    let d = 1 + rand.Next bucket.[i]
    bucket.Transfer i j d

do
  use bucket = new Buckets(10)
  let equalizer = Thread(equalizer bucket)
  let randomizer = Thread(randomizer bucket)
  bucket.Print()
  equalizer.Start()
  randomizer.Start()
  while !transfers < max_transfers do
    Thread.Sleep 100
    bucket.Print()
