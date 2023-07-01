// Almkvist-Giullera formula for pi. Nigel Galloway: August 17th., 2021
let factorial(n:bigint)=MathNet.Numerics.SpecialFunctions.Factorial n
let fN g=(532I*g*g+126I*g+9I)*(factorial(6I*g))/(3I*(factorial g)**6)
[0..9]|>Seq.iter(bigint>>fN>>(*)32I>>printfn "%A\n")
let _,n=Seq.unfold(fun(n,g)->let n=n*(10I**6)+fN g in Some(Isqrt((10I**(145+6*(int g)))/(32I*n)),(n,g+1I)))(0I,0I)|>Seq.pairwise|>Seq.find(fun(n,g)->n=g)
printfn $"""pi to 70 decimal places is %s{(n.ToString()).Insert(1,".")}"""
