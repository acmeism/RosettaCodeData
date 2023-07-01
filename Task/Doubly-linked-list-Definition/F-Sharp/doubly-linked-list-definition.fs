type DListAux<'T> = {mutable prev: DListAux<'T> option; data: 'T; mutable next: DListAux<'T> option}
type DList<'T> = {mutable front: DListAux<'T> option; mutable back: DListAux<'T> option} //'

let empty() = {front=None; back=None}

let addFront dlist elt =
  match dlist.front with
  | None ->
      let e = Some {prev=None; data=elt; next=None}
      dlist.front <- e
      dlist.back <- e
  | Some e2 ->
      let e1 = Some {prev=None; data=elt; next=Some e2}
      e2.prev <- e1
      dlist.front <- e1

let addBack dlist elt =
  match dlist.back with
  | None -> addFront dlist elt
  | Some e2 ->
      let e1 = Some {prev=Some e2; data=elt; next=None}
      e2.next <- e1
      dlist.back <- e1

let addAfter dlist link elt =
  if link.next = dlist.back then addBack dlist elt else
    let e = Some {prev=Some link; data=elt; next=link.next}
    link.next <- e
