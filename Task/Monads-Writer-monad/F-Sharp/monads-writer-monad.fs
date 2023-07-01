// Monads/Writer monad . Nigel Galloway: July 20th., 2022
type Riter<'n>=Riter of 'n * List<string>
let eval=function |Riter(n,g)->(n,g)
let compose f=function |Riter(n,g)->let n,l=eval(f n) in Riter(n,List.append g l)
let initV n=Riter(n,[sprintf "Initial Value %f" n])
let sqrt n=Riter(sqrt n,["Took square root"])
let div n g=Riter(n/g,[sprintf "Divided by %f" n])
let add n g=Riter(n+g,[sprintf "Added %f" n])
let result,log=eval((initV>>compose sqrt>>compose(add 1.0)>>compose(div 2.0))5.0)
log|>List.iter(printfn "%s")
printfn "Final value = %f" result
