[<RequireQualifiedAccess>]
module PriorityQ =

//  type 'a treeElement = Element of uint32 * 'a
  type 'a treeElement = struct val k:uint32 val v:'a new(k,v) = { k=k;v=v } end

  type 'a tree = Node of uint32 * 'a treeElement * 'a tree list

  type 'a heap = 'a tree list

  [<CompilationRepresentation(CompilationRepresentationFlags.UseNullAsTrueValue)>]
  [<NoEquality; NoComparison>]
  type 'a outerheap = | HeapEmpty | HeapNotEmpty of 'a treeElement * 'a heap

  let empty = HeapEmpty

  let isEmpty = function | HeapEmpty -> true | _ -> false

  let inline private rank (Node(r,_,_)) = r

  let inline private root (Node(_,x,_)) = x

  exception Empty_Heap

  let peekMin = function | HeapEmpty -> None
                         | HeapNotEmpty(min, _) -> Some (min.k, min.v)

  let rec private findMin heap =
    match heap with | [] -> raise Empty_Heap //guarded so should never happen
                    | [node] -> root node,[]
                    | topnode::heap' ->
                      let min,subheap = findMin heap' in let rtn = root topnode
                      match subheap with
                        | [] -> if rtn.k > min.k then min,[] else rtn,[]
                        | minnode::heap'' ->
                          let rmn = root minnode
                          if rtn.k <= rmn.k then rtn,heap
                          else rmn,minnode::topnode::heap''

  let private mergeTree (Node(r,kv1,ts1) as tree1) (Node (_,kv2,ts2) as tree2) =
    if kv1.k > kv2.k then Node(r+1u,kv2,tree1::ts2)
    else Node(r+1u,kv1,tree2::ts1)

  let rec private insTree (newnode: 'a tree) heap =
    match heap with
      | [] -> [newnode]
      | topnode::heap' -> if (rank newnode) < (rank topnode) then newnode::heap
                          else insTree (mergeTree newnode topnode) heap'

  let push k v = let kv = treeElement(k,v) in let nn = Node(0u,kv,[])
                   function | HeapEmpty -> HeapNotEmpty(kv,[nn])
                            | HeapNotEmpty(min,heap) -> let nmin = if k > min.k then min else kv
                                                        HeapNotEmpty(nmin,insTree nn heap)

  let rec private merge' heap1 heap2 = //doesn't guaranty minimum tree node as head!!!
    match heap1,heap2 with
      | _,[] -> heap1
      | [],_ -> heap2
      | topheap1::heap1',topheap2::heap2' ->
        match compare (rank topheap1) (rank topheap2) with
          | -1 -> topheap1::merge' heap1' heap2
          | 1 -> topheap2::merge' heap1 heap2'
          | _ -> insTree (mergeTree topheap1 topheap2) (merge' heap1' heap2')

  let merge oheap1 oheap2 = match oheap1,oheap2 with
                              | _,HeapEmpty -> oheap1
                              | HeapEmpty,_ -> oheap2
                              | HeapNotEmpty(min1,heap1),HeapNotEmpty(min2,heap2) ->
                                  let min = if min1.k > min2.k then min2 else min1
                                  HeapNotEmpty(min,merge' heap1 heap2)

  let rec private removeMinTree = function
                          | [] -> raise Empty_Heap // will never happen as already guarded
                          | [node] -> node,[]
                          | t::ts -> let t',ts' = removeMinTree ts
                                     if (root t).k <= (root t').k then t,ts else t',t::ts'

  let deleteMin =
    function | HeapEmpty -> HeapEmpty
             | HeapNotEmpty(_,heap) ->
               match heap with
                 | [] -> HeapEmpty // should never occur: non empty heap with no elements
                 | [Node(_,_,heap')] -> match heap' with
                                          | [] -> HeapEmpty
                                          | _ -> let min,_ = findMin heap'
                                                 HeapNotEmpty(min,heap')
                 | _::_ -> let Node(_,_,ts1),ts2 = removeMinTree heap
                           let nheap = merge' (List.rev ts1) ts2 in let min,_ = findMin nheap
                           HeapNotEmpty(min,nheap)

  let replaceMin k v pq = push k v (deleteMin pq)

  let fromSeq sq = Seq.fold (fun pq (k, v) -> push k v pq) empty sq

  let popMin pq = match peekMin pq with
                      | None -> None
                      | Some(kv) -> Some(kv, deleteMin pq)

  let toSeq pq = Seq.unfold popMin pq

  let sort sq = sq |> fromSeq |> toSeq

  let adjust f pq = pq |> toSeq |> Seq.map (fun (k, v) -> f k v) |> fromSeq
