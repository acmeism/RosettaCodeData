type IChurch =
  abstract Apply : ('a -> 'a) -> ('a -> 'a)

let zeroChurch = { new IChurch with override __.Apply _ = id }
let oneChurch = { new IChurch with override __.Apply f = f }
let succChurch (n: IChurch) =
  { new IChurch with override __.Apply f = fun x -> f (n.Apply f x) }
let addChurch (m: IChurch) (n: IChurch) =
  { new IChurch with override __.Apply f = fun x -> m.Apply f (n.Apply f x) }
let multChurch (m: IChurch) (n: IChurch) =
  { new IChurch with override __.Apply f = m.Apply (n.Apply f) }
let expChurch (m: IChurch) (n: IChurch) =
  { new IChurch with override __.Apply f = n.Apply m.Apply f }
let iszeroChurch (n: IChurch) =
  { new IChurch with
      override __.Apply f = n.Apply (fun _ -> zeroChurch.Apply) oneChurch.Apply f }
let predChurch (n: IChurch) =
  { new IChurch with
      override __.Apply f = fun x -> n.Apply (fun g h -> h (g f))
                                             (fun _ -> x) id }
let subChurch (m: IChurch) (n: IChurch) =
  { new IChurch with override __.Apply f = (n.Apply predChurch m).Apply f }
let divChurch (dvdnd: IChurch) (dvsr: IChurch) =
  let rec divr (n: IChurch) (d: IChurch) =
    { new IChurch with
        override __.Apply f =
          ((fun (v: IChurch) -> // test v for Church zeroChurch...
              v.Apply (fun _ -> (succChurch (divr v d)).Apply) // if not zeroChurch
                                zeroChurch.Apply)(subChurch n d)) f }
  divr (succChurch dvdnd) dvsr

let chtoi (ch: IChurch) = ch.Apply ((+) 1) 0
let itoch i = List.fold (>>) id (List.replicate i succChurch) zeroChurch

#nowarn "25" // skip incomplete pattern warning
[<EntryPoint>]
let main _ =
    let [c3; c4; c11; c12] = List.map itoch [3; 4; 11; 12]

    [ addChurch c3 c4
    ; multChurch c3 c4
    ; expChurch c3 c4
    ; expChurch c4 c3
    ; iszeroChurch zeroChurch
    ; iszeroChurch oneChurch
    ; predChurch c3
    ; subChurch c11 c3
    ; divChurch c11 c3
    ; divChurch c12 c3
    ] |> List.map chtoi |> printfn "%A"
    0 // return an integer exit code
