// Display a linear combination. Nigel Galloway: March 28th., 2018
let fN g =
  let rec fG n g=match g with
                 |0::g    ->                        fG (n+1) g
                 |1::g    -> printf "+e(%d)" n;     fG (n+1) g
                 |(-1)::g -> printf "-e(%d)" n;     fG (n+1) g
                 |i::g    -> printf "%+de(%d)" i n; fG (n+1) g
                 |_       -> printfn ""
  let rec fN n g=match g with
                 |0::g    ->                        fN (n+1) g
                 |1::g    -> printf "e(%d)" n;      fG (n+1) g
                 |(-1)::g -> printf "-e(%d)" n;     fG (n+1) g
                 |i::g    -> printf "%de(%d)" i n;  fG (n+1) g
                 |_       -> printfn "0"
  fN 1 g
