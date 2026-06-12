// Lagrange Interpolation. Nigel Galloway: September 5th., 2023
let symbol=MathNet.Symbolics.SymbolicExpression.Variable
let qi=MathNet.Symbolics.SymbolicExpression.FromInt32
let eval (g:MathNet.Symbolics.SymbolicExpression) x=let n=Map["x",MathNet.Symbolics.FloatingPoint.Real x] in MathNet.Symbolics.Evaluate.evaluate n g.Expression
let fN g=let x=symbol "x" in g|>List.fold(fun z c->(x-c)*z)(qi 1)
let fG(n,g)=let n,g=n|>List.map qi,g|>List.map qi in List.map2(fun i g->i,g,n|>List.except [i]) n g
let LIF n=fG n|>List.sumBy(fun(ci,bi,c)->bi*(fN c)/(c|>List.fold(fun z c->(ci-c)*z)(qi 1)))
printfn $"%s{LIF([1;2;3;4],[1;4;1;5]).Expand().ToString()}"
