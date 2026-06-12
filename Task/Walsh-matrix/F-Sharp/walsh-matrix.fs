// Walsh matrix. Nigel Galloway: August 31st., 2023
open MathNet.Numerics
open MathNet.Numerics.LinearAlgebra
let walsh()=let w2=matrix [[1.0;1.0];[1.0;-1.0]] in Seq.unfold(fun n->Some(n,w2.KroneckerProduct n)) w2
walsh() |> Seq.take 5 |> Seq.iter(fun n->printfn "%s" (n.ToMatrixString()))
