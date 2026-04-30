exception Out_of_bounds
type 'a bounds = { min: 'a; max: 'a }
type 'a bounded = { value: 'a; bounds: 'a bounds }
let mk_bounds min max = { min=min; max=max }
let check_bounds value bounds = if value < bounds.min || value > bounds.max then raise Out_of_bounds
let mk_bounded value bounds = check_bounds value bounds; { value=value; bounds=bounds }
let op f a b =
  if a.bounds <> b.bounds then raise(System.Exception "different bounds")
  let res = f a.value b.value in check_bounds res a.bounds
  (mk_bounded res a.bounds)
let range = mk_bounds 1 10
let a,b=mk_bounded 2 range,mk_bounded 6 range
printfn "%A" (op ( + ) a b)
try printfn "%A" (op ( * ) a b) with ex->printfn "%s" (ex.ToString())
