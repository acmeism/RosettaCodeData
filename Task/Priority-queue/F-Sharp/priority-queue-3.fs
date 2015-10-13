[<RequireQualifiedAccess>]
module PriorityQ =

  type HeapEntry<'T> = struct val k:uint32 val v:'T new(k,v) = { k=k;v=v } end
  type MinHeapTree<'T> = ResizeArray<HeapEntry<'T>>

  let empty<'T> = MinHeapTree<HeapEntry<'T>>()

  let isEmpty (pq: MinHeapTree<_>) = pq.Count = 0

  let size (pq: MinHeapTree<_>) = let cnt = pq.Count
                                  if cnt = 0 then 0 else cnt - 1

  let peekMin (pq:MinHeapTree<_>) = if pq.Count > 1 then let kv = pq.[0]
                                                         Some (kv.k, kv.v) else None

  let push k v (pq:MinHeapTree<_>) =
    if pq.Count = 0 then pq.Add(HeapEntry(0xFFFFFFFFu,v)) //add an extra entry so there's always a right max node
    let mutable nxtlvl = pq.Count in let mutable lvl = nxtlvl <<< 1 //1 past index of value added times 2
    pq.Add(pq.[nxtlvl - 1]) //copy bottom entry then do bubble up while less than next level up
    while ((lvl <- lvl >>> 1); nxtlvl <- nxtlvl >>> 1; nxtlvl <> 0) do
      let t = pq.[nxtlvl - 1] in if t.k > k then pq.[lvl - 1] <- t else lvl <- lvl <<< 1; nxtlvl <- 0 //causes loop break
    pq.[lvl - 1] <-  HeapEntry(k,v); pq

  let inline private siftdown k v ndx (pq: MinHeapTree<_>) =
    let mutable i = ndx in let mutable ni = i in let cnt = pq.Count - 1
    while (ni <- ni + ni + 1; ni < cnt) do
      let lk = pq.[ni].k in let rk = pq.[ni + 1].k in let oi = i
      let k = if k > lk then i <- ni; lk else k in if k > rk then ni <- ni + 1; i <- ni
      if i <> oi then pq.[oi] <- pq.[i] else ni <- cnt //causes loop break
    pq.[i] <- HeapEntry(k,v)

  let replaceMin k v (pq:MinHeapTree<_>) = siftdown k v 0 pq; pq

  let deleteMin (pq:MinHeapTree<_>) =
    let lsti = pq.Count - 2
    if lsti <= 0 then pq.Clear(); pq else
    let lstkv = pq.[lsti]
    pq.RemoveAt(lsti)
    siftdown lstkv.k lstkv.v 0 pq; pq

  let adjust f (pq:MinHeapTree<_>) = //adjust all the contents using the function, then re-heapify
    let cnt = pq.Count - 1
    let rec adj i =
      let lefti = i + i + 1 in let righti = lefti + 1
      let ckv = pq.[i] in let (nk, nv) = f ckv.k ckv.v
      if righti < cnt then adj righti
      if lefti < cnt then adj lefti; siftdown nk nv i pq
      else pq.[i] <- HeapEntry(nk, nv)
    adj 0; pq

  let fromSeq sq =
    if Seq.isEmpty sq then empty
    else let pq = new MinHeapTree<_>(sq |> Seq.map (fun (k, v) -> HeapEntry(k, v)))
         let sz = pq.Count in let lkv = pq.[sz - 1]
         pq.Add(HeapEntry(UInt32.MaxValue, lkv.v))
         let rec build i =
           let lefti = i + i + 1
           if lefti < sz then
             let righti = lefti + 1 in build lefti; build righti
             let ckv = pq.[i] in siftdown ckv.k ckv.v i pq
         build 0; pq

  let merge (pq1:MinHeapTree<_>) (pq2:MinHeapTree<_>) =
    if pq2.Count = 0 then pq1 else
    if pq1.Count = 0 then pq2 else
    let pq = empty
    pq.AddRange(pq1); pq.RemoveAt(pq.Count - 1)
    pq.AddRange(pq2)
    let sz = pq.Count - 1
    let rec build i =
      let lefti = i + i + 1
      if lefti < sz then
        let righti = lefti + 1 in build lefti; build righti
        let ckv = pq.[i] in siftdown ckv.k ckv.v i pq
    build 0; pq

  let popMin pq = match peekMin pq with
                   | None     -> None
                   | Some(kv) -> Some(kv, deleteMin pq)

  let toSeq pq = Seq.unfold popMin pq

  let sort sq = sq |> fromSeq |> toSeq
