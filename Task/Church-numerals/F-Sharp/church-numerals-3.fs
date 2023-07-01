#nowarn "25" // eliminate incomplete pattern match warning

// types...
type Church<'a> = Church of (Church<'a> -> Church<'a>)
                | ArityZero of 'a
let applyChurch (Church chf) charg =
  chf charg
let composeChurch (Church chlf) (Church chrf) =
  Church <| fun f -> (chlf << chrf) f

let churchZero<'a> = Church <| fun (_: Church<'a>) -> Church id
let churchOne = Church id
let succChurch (Church chf) =
  Church <| fun f -> composeChurch f <| chf f
let addChurch cha chb =
  Church <| fun f -> composeChurch (applyChurch cha f) (applyChurch chb f)
let multChurch cha chb =
  composeChurch cha chb
let expChurch chbs chexp =
  applyChurch chexp chbs
let isZeroChurch ch =
  applyChurch (applyChurch ch (Church <| fun _ -> churchZero)) churchOne
let predChurch ch =
  Church <| fun f -> Church <| fun x ->
    let prdf = Church <| fun g -> Church <| fun h ->
                            applyChurch h (applyChurch g f)
    applyChurch (applyChurch (applyChurch ch prdf)
                             (Church <| fun _ -> x)) <| Church id
let subChurch cha chb =
  applyChurch (applyChurch chb <| Church predChurch) cha

let divChurch chdvdnd chdvsr =
  let rec divr n =
    let loop v = Church <| fun _ -> succChurch <| divr v
    let tst v = applyChurch (applyChurch v <| loop v) churchZero
    tst <| subChurch n chdvsr
  divr <| succChurch chdvdnd

let intToChurch<'a> i =
  List.fold (>>) id (List.replicate i succChurch) churchZero<'a>
let churchToInt ch =
  let succInt = Church <| fun (ArityZero v) -> ArityZero <| v + 1
  match applyChurch (applyChurch ch succInt) <| ArityZero 0 with
    ArityZero r -> r

[<EntryPoint>]
let main _ =
  let [c3; c4; c11; c12] = List.map intToChurch [3; 4; 11; 12]
  [ addChurch c3 c4
  ; multChurch c3 c4
  ; expChurch c3 c4
  ; expChurch c4 c3
  ; isZeroChurch churchZero
  ; isZeroChurch c3
  ; predChurch c4
  ; subChurch c11 c3
  ; divChurch c11 c3
  ; divChurch c12 c3
  ] |> List.map churchToInt |> printfn "%A"
  0 // return an integer exit code
