// Two Sum : Nigel Galloway December 5th., 2017
let fN n i =
  let rec fN n e =
    match n with
    |n::g when n < i -> match List.mapi(fun g i-> (n,i,g)) g |> List.tryFind(fun (n,g,l)->(n+g)=i) with
                        |Some (n,g,l) -> [e;e+l+1]
                        |_            -> fN g (e+1)
    |_               -> []
  fN n 0
printfn "%A" (fN [0; 2; 11; 19; 90] 21)
