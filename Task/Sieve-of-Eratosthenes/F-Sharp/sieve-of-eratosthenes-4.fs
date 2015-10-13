[<RequireQualifiedAccess>]
module MinHeap =

  type HeapEntry<'V> = struct val k:uint32 val v:'V new(k,v) = {k=k;v=v} end
  [<CompilationRepresentation(CompilationRepresentationFlags.UseNullAsTrueValue)>]
  [<NoEquality; NoComparison>]
  type PQ<'V> =
         | Mt
         | Br of HeapEntry<'V> * PQ<'V> * PQ<'V>

  let empty = Mt

  let peekMin = function | Br(kv, _, _) -> Some(kv.k, kv.v)
                         | _            -> None

  let rec push wk wv =
    function | Mt -> Br(HeapEntry(wk, wv), Mt, Mt)
             | Br(vkv, ll, rr) ->
                 if wk <= vkv.k then
                   Br(HeapEntry(wk, wv), push vkv.k vkv.v rr, ll)
                 else Br(vkv, push wk wv rr, ll)

  let private siftdown wk wv pql pqr =
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
