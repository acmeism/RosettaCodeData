[<RequireQualifiedAccess>]
module PriorityQ =

  type HeapEntry<'V> = struct val k:uint32 val v:'V new(k,v) = {k=k;v=v} end
  [<CompilationRepresentation(CompilationRepresentationFlags.UseNullAsTrueValue)>]
  [<NoEquality; NoComparison>]
  type PQ<'V> =
         | Mt
         | Br of HeapEntry<'V> * PQ<'V> * PQ<'V>

  let empty = Mt

  let isEmpty = function | Mt -> true
                         | _  -> false

  // Return number of elements in the priority queue.
  // /O(log(n)^2)/
  let rec size = function
    | Mt -> 0
    | Br(_, ll, rr) ->
        let n = size rr
        // rest n p q, where n = size ll, and size ll - size rr = 0 or 1
        // returns 1 + size ll - size rr.
        let rec rest n pl pr =
          match pl with
            | Mt -> 1
            | Br(_, pll, plr) ->
                match pr with
                  | Mt -> 2
                  | Br(_, prl, prr) ->
                      let nm1 = n - 1 in let d = nm1 >>> 1
                      if (nm1 &&& 1) = 0
                        then rest d pll prl // subtree sizes: (d or d+1), d; d, d
                        else rest d plr prr // subtree sizes: d+1, (d or d+1); d+1, d
        2 * n + rest n ll rr

  let peekMin = function | Br(kv, _, _) -> Some(kv.k, kv.v)
                         | _            -> None

  let rec push wk wv =
    function | Mt -> Br(HeapEntry(wk, wv), Mt, Mt)
             | Br(vkv, ll, rr) ->
                 if wk <= vkv.k then
                   Br(HeapEntry(wk, wv), push vkv.k vkv.v rr, ll)
                 else Br(vkv, push wk wv rr, ll)

  let inline private siftdown wk wv pql pqr =
    let rec sift pl pr =
      match pl with
        | Mt -> Br(HeapEntry(wk, wv), Mt, Mt)
        | Br(vkvl, pll, plr) ->
            match pr with
              | Mt -> if wk <= vkvl.k then Br(HeapEntry(wk, wv), pl, Mt)
                      else Br(vkvl, Br(HeapEntry(wk, wv), Mt, Mt), Mt)
              | Br(vkvr, prl, prr) ->
                  if wk <= vkvl.k && wk <= vkvr.k then Br(HeapEntry(wk, wv), pl, pr)
                  elif vkvl.k <= vkvr.k then Br(vkvl, sift pll plr, pr)
                  else Br(vkvr, pl, sift prl prr)
    sift pql pqr

  let replaceMin wk wv = function | Mt -> Mt
                                  | Br(_, ll, rr) -> siftdown wk wv ll rr

  let deleteMin = function
        | Mt -> Mt
        | Br(_, ll, Mt) -> ll
        | Br(vkv, ll, rr) ->
          let rec leftrem = function | Mt -> vkv, Mt // should never happen
                                     | Br(kvd, Mt, _) -> kvd, Mt
                                     | Br(vkv, Br(kvd, _, _), Mt) ->
                                                 kvd, Br(vkv, Mt, Mt)
                                     | Br(vkv, pl, pr) -> let kvd, pqd = leftrem pl
                                                          kvd, Br(vkv, pr, pqd)
          let (kvd, pqd) = leftrem ll
          siftdown kvd.k kvd.v rr pqd;

  let adjust f pq =
        let rec adj = function
              | Mt -> Mt
              | Br(vkv, ll, rr) -> let nk, nv = f vkv.k vkv.v
                                   siftdown nk nv (adj ll) (adj rr)
        adj pq

  let fromSeq sq =
    if Seq.isEmpty sq then Mt
    else let nmrtr = sq.GetEnumerator()
         let rec build lvl = if lvl = 0 || not (nmrtr.MoveNext()) then Mt
                             else let ck, cv = nmrtr.Current
                                  let lft = lvl >>> 1
                                  let rght = (lvl - 1) >>> 1
                                  siftdown ck cv (build lft) (build rght)
         build (sq |> Seq.length)

  let merge (pq1:PQ<_>) (pq2:PQ<_>) = // merges without using a sequence
    match pq1 with
      | Mt -> pq2
      | _ ->
        match pq2 with
          | Mt -> pq1
          | _ ->
            let rec zipper lvl pq rest =
              if lvl = 0 then Mt, pq, rest else
              let lft = lvl >>> 1 in let rght = (lvl - 1) >>> 1
              match pq with
                | Mt ->
                  match rest with
                    | [] | Mt :: _ -> Mt, pq, [] // Mt in list never happens
                    | Br(kv, ll, Mt) :: tl ->
                        let pl, pql, rstl = zipper lft ll tl
                        let pr, pqr, rstr = zipper rght pql rstl
                        siftdown kv.k kv.v pl pr, pqr, rstr
                    | Br(kv, ll, rr) :: tl ->
                        let pl, pql, rstl = zipper lft ll (rr :: tl)
                        let pr, pqr, rstr = zipper rght pql rstl
                        siftdown kv.k kv.v pl pr, pqr, rstr
                | Br(kv, ll, Mt) ->
                    let pl, pql, rstl = zipper lft ll rest
                    let pr, pqr, rstr = zipper rght pql rstl
                    siftdown kv.k kv.v pl pr, pqr, rstr
                | Br(kv, ll, rr) ->
                    let pl, pql, rstl = zipper lft ll (rr :: rest)
                    let pr, pqr, rstr = zipper rght pql rstl
                    siftdown kv.k kv.v pl pr, pqr, rstr
            let sz = size pq1 + size pq2
            let pq, _, _ = zipper sz pq1 [pq2] in pq

  let popMin pq = match peekMin pq with
                      | None -> None
                      | Some(kv) -> Some(kv, deleteMin pq)

  let toSeq pq = Seq.unfold popMin pq

  let sort sq = sq |> fromSeq |> toSeq
