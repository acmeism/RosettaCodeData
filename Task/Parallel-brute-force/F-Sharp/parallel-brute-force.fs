(*
Nigel Galloway February 21st., 2017
*)
let N n i g e l =
  let G = function
    |"3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b"->Some(string n+string i+string g+string e+string l)
    |"74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f"->Some(string n+string i+string g+string e+string l)
    |"1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad"->Some(string n+string i+string g+string e+string l)
    |_->None
  G ([|byte n;byte i;byte g;byte e;byte l|]|>System.Security.Cryptography.SHA256.Create().ComputeHash|>Array.map(fun (x:byte)->System.String.Format("{0:x2}",x))|>String.concat "")
open System.Threading.Tasks
let n1 = Task.Factory.StartNew(fun ()->['a'..'m']|>List.collect(fun n->['a'..'m']|>List.collect(fun i->['a'..'m']|>List.collect(fun g->['a'..'z']|>List.collect(fun e->['a'..'z']|>List.choose(fun l->N n i g e l))))))
let n2 = Task.Factory.StartNew(fun ()->['a'..'m']|>List.collect(fun n->['a'..'m']|>List.collect(fun i->['n'..'z']|>List.collect(fun g->['a'..'z']|>List.collect(fun e->['a'..'z']|>List.choose(fun l->N n i g e l))))))
let n3 = Task.Factory.StartNew(fun ()->['a'..'m']|>List.collect(fun n->['n'..'z']|>List.collect(fun i->['a'..'m']|>List.collect(fun g->['a'..'z']|>List.collect(fun e->['a'..'z']|>List.choose(fun l->N n i g e l))))))
let n4 = Task.Factory.StartNew(fun ()->['a'..'m']|>List.collect(fun n->['n'..'z']|>List.collect(fun i->['n'..'z']|>List.collect(fun g->['a'..'z']|>List.collect(fun e->['a'..'z']|>List.choose(fun l->N n i g e l))))))
let n5 = Task.Factory.StartNew(fun ()->['n'..'z']|>List.collect(fun n->['a'..'m']|>List.collect(fun i->['a'..'m']|>List.collect(fun g->['a'..'z']|>List.collect(fun e->['a'..'z']|>List.choose(fun l->N n i g e l))))))
let n6 = Task.Factory.StartNew(fun ()->['n'..'z']|>List.collect(fun n->['a'..'m']|>List.collect(fun i->['n'..'z']|>List.collect(fun g->['a'..'z']|>List.collect(fun e->['a'..'z']|>List.choose(fun l->N n i g e l))))))
let n7 = Task.Factory.StartNew(fun ()->['n'..'z']|>List.collect(fun n->['n'..'z']|>List.collect(fun i->['a'..'m']|>List.collect(fun g->['a'..'z']|>List.collect(fun e->['a'..'z']|>List.choose(fun l->N n i g e l))))))
let n8 = Task.Factory.StartNew(fun ()->['n'..'z']|>List.collect(fun n->['n'..'z']|>List.collect(fun i->['n'..'z']|>List.collect(fun g->['a'..'z']|>List.collect(fun e->['a'..'z']|>List.choose(fun l->N n i g e l))))))

for r in n1.Result@n2.Result@n3.Result@n4.Result@n5.Result@n6.Result@n7.Result@n8.Result do printfn "%s" r
