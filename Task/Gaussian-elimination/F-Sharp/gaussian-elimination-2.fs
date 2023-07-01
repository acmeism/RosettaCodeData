let test=[[ -6I; -18I;  13I;   6I;  -6I; -15I;  -2I;  -9I;  -231I];
          [  2I;  20I;   9I;   2I;  16I; -12I; -18I;  -5I;   647I];
          [ 23I;  18I; -14I; -14I;  -1I;  16I;  25I; -17I;  -907I];
          [ -8I;  -1I; -19I;   4I;   3I; -14I;  23I;   8I;   248I];
          [ 25I;  20I;  -6I;  15I;   0I; -10I;   9I;  17I;  1316I];
          [-13I;  -1I;   3I;   5I;  -2I;  17I;  14I; -12I; -1080I];
          [ 19I;  24I; -21I;  -5I; -19I;   0I; -24I; -17I;  1006I];
          [ 20I;  -3I; -14I; -16I; -23I; -25I; -15I;  20I;  1496I]]
let fN (n,g)=cN2S(π(rI2cf n g))
gelim test |> List.map fN |> List.iteri(fun i n->(printfn "x[%d]=%1.14f " (i+1) (snd (Seq.pairwise n|> Seq.find(fun (n,g)->n-g < 0.0000000000001M)))))
