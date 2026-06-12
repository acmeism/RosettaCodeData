// Apéry's constant. Nigel Galloway: March 3rd., 2023
open MathNet.Numerics
let fact=let g=Seq.unfold(fun(n,g)->Some(n,(n*g,g+1N)))(1N,2N)|>Seq.cache in (fun n->Seq.item (n-1) g)
let fN g=let g=BigRational.FromInt g in 126392N*g**5+412708N*g**4+531578N*g**3+336367N*g**2+104000N*g+12463N
let fG n g l=let i=n/g in (int i,Seq.unfold(fun(n,i)->if i=0 then None else let l=n/g in Some(int l,(10I*(n-l*g),i-1)))(10I*(n-i*g),l))
let r3=Seq.initInfinite(fun g->BigRational.PowN(((+)1>>BigRational.FromInt>>BigRational.Reciprocal)g,3))|>Seq.take 1000|>Seq.sum
let ma=(5N/2N)*(Seq.unfold(fun(n,g,l)->Some(n*g,(-n,(fact l)*(fact l)/(fact(2*l)*BigRational.FromInt(pown l 3)),l+1)))(1N,1N/2N,2)|>Seq.take 158|>Seq.sum)
let sw=(1N/24N)*(Seq.unfold(fun(n,g,l)->Some(n*g,(-n,(fact(2*l+1)**3*fact(2*l)**3*(fact l)**3*(fN l))/(fact(3*l+2)*(fact(4*l+3)**3)),l+1)))(1N,12463N/432N,1)|>Seq.take 20|>Seq.sum)
[r3;ma;sw]|>List.iter(fun n->let n,g=fG (n.Numerator) (n.Denominator) 100 in printf $"%d{n}."; g|>Seq.iter(printf "%d"); printfn "")
