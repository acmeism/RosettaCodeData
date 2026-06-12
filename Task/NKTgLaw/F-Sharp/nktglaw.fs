//NKTgLaw. Nigel Galloway: February 23rd., 2026
type nktg={p:float;nktg1:float;nktg2:float;tendency1:string;tendency2:string}
let tendency1=function n when n>0.0->"Moving away from stable state"|n when n<0.0->"Moving toward stable state" |_->"Stable equilibrium"
let tendency2=function n when n>0.0->"Mass variation supports movement"|n when n<0.0->"Mass variation resists movement" |_->"No mass variation effect"
let nktg x v m dm_dt=let p=m*v in let nktg1,nktg2=x*p,dm_dt*p
                     {p=p;nktg1=nktg1;nktg2=nktg2;tendency1=tendency1 nktg1;tendency2=tendency2 nktg2}
printfn "%A" (nktg 2.0 3.0 4.0 -0.5)
