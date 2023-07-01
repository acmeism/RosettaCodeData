// Lah numbers. Nigel Galloway: January 3rd., 2023
let fact(n:int)=let rec fact=function n when n=0I->1I |n->n*fact(n-1I) in fact(bigint n)
let rec lah=function (_,0)|(0,_)->0I |(n,1)->fact n |(n,g) when n=g->1I |(n,g)->((fact n)*(fact(n-1)))/((fact g)*(fact(g-1)))/(fact(n-g))
for n in {0..12} do (for g in {0..n} do printf $"%A{lah(n,g)} "); printfn ""
printfn $"\n\n%A{seq{for n in 1..99->lah(100,n)}|>Seq.max}"
