// Shoelace formula for area of polygon. Nigel Galloway: April 11th., 2018
let fN(n::g) = abs(List.pairwise(n::g@[n])|>List.fold(fun n ((nα,gα),(nβ,gβ))->n+(nα*gβ)-(gα*nβ)) 0.0)/2.0
printfn "%f" (fN [(3.0,4.0); (5.0,11.0); (12.0,8.0); (9.0,5.0); (5.0,6.0)])
