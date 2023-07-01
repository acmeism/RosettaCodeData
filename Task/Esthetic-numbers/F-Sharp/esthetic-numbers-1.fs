// Generate Esthetic Numbers. Nigel Galloway: March 21st., 2020
let rec fN Σ n g = match g with h::t -> match List.head h with
                                         0 -> fN ((1::h)::Σ) n t
                                        |g when g=n-1 -> fN ((g-1::h)::Σ) n t
                                        |g -> fN ((g-1::h)::(g+1::h)::Σ) n t
                               |_    -> Σ

let Esthetic n = let Esthetic, g = fN [] n, [1..n-1] |> List.map(fun n->[n])
                 Seq.unfold(fun n->Some(n,Esthetic(List.rev n)))(g) |> Seq.concat

let EtoS n = let g = "0123456789abcdef".ToCharArray()
             n |> List.map(fun n->g.[n]) |> List.rev |> Array.ofList |> System.String
