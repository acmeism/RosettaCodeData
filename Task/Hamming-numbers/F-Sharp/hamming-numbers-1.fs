type LazyList<'a> = Cons of 'a * Lazy<LazyList<'a>>

let rec hammings() =
  let rec (-|-) (Cons(x, nxf) as xs) (Cons(y, nyf) as ys) =
    if x < y then Cons(x, lazy(nxf.Value -|- ys))
    elif x > y then Cons(y, lazy(xs -|- nyf.Value))
    else Cons(x, lazy(nxf.Value -|- nyf.Value))
  let rec inf_map f (Cons(x, nxf)) =
    Cons(f x, lazy(inf_map f nxf.Value))
  Cons(1I, lazy(let x = inf_map ((*) 2I) hamming
                let y = inf_map ((*) 3I) hamming
                let z = inf_map ((*) 5I) hamming
                x -|- y -|- z))

// testing...
[<EntryPoint>]
let main args =
  let rec iterLazyListFor f n (Cons(v, rf)) =
    if n > 0 then f v; iterLazyListFor f (n - 1) rf.Value
  let rec nthLazyList n ((Cons(v, rf)) as ll) =
    if n <= 1 then v else nthLazyList (n - 1) rf.Value
  printf "( "; iterLazyListFor (printf "%A ") 20 (hammings()); printfn ")"
  printfn "%A" (hammings() |> nthLazyList 1691)
  printfn "%A" (hammings() |> nthLazyList 1000000)
  0
