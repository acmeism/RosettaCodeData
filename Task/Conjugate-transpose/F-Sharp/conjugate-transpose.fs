// Conjugate transpose. Nigel Galloway: January 10th., 2022
let fN g=let g=g|>List.map(List.map(fun(n,g)->System.Numerics.Complex(n,g)))|>MathNet.Numerics.LinearAlgebra.MatrixExtensions.matrix in (g,g.ConjugateTranspose())
let fG n g=(MathNet.Numerics.LinearAlgebra.Matrix.inverse n-g)|>MathNet.Numerics.LinearAlgebra.Matrix.forall(fun(n:System.Numerics.Complex)->abs n.Real<1e-14&&abs n.Imaginary<1e-14)
let test=[fN [[(3.0,0.0);(2.0,1.0)];[(2.0,-1.0);(1.0,0.0)]];fN [[(1.0,0.0);(1.0,0.0);(0.0,0.0)];[(0.0,0.0);(1.0,0.0);(1.0,0.0)];[(1.0,0.0);(0.0,0.0);(1.0,0.0)]];fN [[(1.0/sqrt 2.0,0.0);(1.0/sqrt 2.0,0.0);(0.0,0.0)];[(0.0,1.0/sqrt 2.0);(0.0,-1.0/sqrt 2.0);(0.0,0.0)];[(0.0,0.0);(0.0,0.0);(0.0,1.0)]]]
test|>List.iter(fun(n,g)->printfn $"Matrix\n------\n%A{n}\nConjugate transposed\n--------------------\n%A{g}\nIs hermitian: %A{n.IsHermitian()}\nIs normal:    %A{n*g=g*n}\nIs unitary:   %A{fG n g}\n")
