// Kronecker product. Nigel Galloway: August 31st., 2023
open MathNet.Numerics
open MathNet.Numerics.LinearAlgebra
let m1,m2,m3,m4=matrix [[1.0;2.0];[3.0;4.0]],matrix [[0.0;5.0];[6.0;7.0]],matrix [[0.0;1.0;0.0];[1.0;1.0;1.0];[0.0;1.0;0.0]],matrix [[1.0;1.0;1.0;1.0];[1.0;0.0;0.0;1.0];[1.0;1.0;1.0;1.0]]
printfn $"{(m1.KroneckerProduct m2).ToMatrixString()}"
printfn $"{(m3.KroneckerProduct m4).ToMatrixString()}"
