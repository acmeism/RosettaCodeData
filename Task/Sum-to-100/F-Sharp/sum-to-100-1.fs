(*
Generate the data set
Nigel Galloway February 22nd., 2017
*)
type N = {n:string; g:int}
let N = seq {
  let rec fn n i g e l = seq {
    match i with
    |9 -> yield {n=l + "-9"; g=g+e-9}
          yield {n=l + "+9"; g=g+e+9}
          yield {n=l +  "9"; g=g+e*10+9*n}
    |_ -> yield! fn -1 (i+1) (g+e) -i (l + string -i)
          yield! fn  1 (i+1) (g+e)  i (l + "+" + string i)
          yield! fn  n (i+1) g (e*10+i*n) (l + string i)
  }
  yield! fn  1 2 0  1  "1"
  yield! fn -1 2 0 -1 "-1"
}
