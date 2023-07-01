// QR decomposition. Nigel Galloway: January 11th., 2022
let n=[[12.0;-51.0;4.0];[6.0;167.0;-68.0];[-4.0;24.0;-41.0]]|>MathNet.Numerics.LinearAlgebra.MatrixExtensions.matrix
let g=n|>MathNet.Numerics.LinearAlgebra.Matrix.qr
printfn $"Matrix\n------\n%A{n}\nQ\n-\n%A{g.Q}\nR\n-\n%A{g.R}"
