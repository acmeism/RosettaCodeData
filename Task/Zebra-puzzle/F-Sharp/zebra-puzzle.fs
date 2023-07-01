(*Here I solve the Zebra puzzle using Plain Changes, definitely a challenge to some campanoligist to solve it using Grandsire Doubles.
  Nigel Galloway: January 27th., 2017 *)
type N = |English=0 |Swedish=1|Danish=2    |German=3|Norwegian=4
type I = |Tea=0     |Coffee=1 |Milk=2      |Beer=3  |Water=4
type G = |Dog=0     |Birds=1  |Cats=2      |Horse=3 |Zebra=4
type E = |Red=0     |Green=1  |White=2     |Blue=3  |Yellow=4
type L = |PallMall=0|Dunhill=1|BlueMaster=2|Prince=3|Blend=4
type NIGELz={Nz:N[];Iz:I[];Gz:G[];Ez:E[];Lz:L[]}
let fn (i:'n[]) g (e:'g[]) l =                            //coincident?
  let rec _fn = function
    |5                                -> false
    |ig when (i.[ig]=g && e.[ig]=l)   -> true
    |ig                               -> _fn (ig+1)
  _fn 0
let fi (i:'n[]) g (e:'g[]) l =                            //leftof?
  let rec _fn = function
    |4                                -> false
    |ig when (i.[ig]=g && e.[ig+1]=l) -> true
    |ig                               -> _fn (ig+1)
  _fn 0
let fg (i:'n[]) g (e:'g[]) l = (fi i g e l || fi e l i g) //adjacent?
let  n = Ring.PlainChanges [|for n in System.Enum.GetValues(typeof<N>)->n:?>N|]|>Seq.filter(fun n->n.[0]=N.Norwegian)         //#10
let  i = Ring.PlainChanges [|for n in System.Enum.GetValues(typeof<I>)->n:?>I|]|>Seq.filter(fun n->n.[2]=I.Milk)              //# 9
let  g = Ring.PlainChanges [|for n in System.Enum.GetValues(typeof<G>)->n:?>G|]
let  e = Ring.PlainChanges [|for n in System.Enum.GetValues(typeof<E>)->n:?>E|]|>Seq.filter(fun n->fi n E.Green n E.White)    //# 5
let  l = Ring.PlainChanges [|for n in System.Enum.GetValues(typeof<L>)->n:?>L|]
match n|>Seq.map(fun n->{Nz=n;Iz=[||];Gz=[||];Ez=[||];Lz=[||]})
       |>Seq.collect(fun n->i|>Seq.map(fun i->{n with Iz=i}))|>Seq.filter(fun n-> fn n.Nz N.Danish    n.Iz I.Tea)             //# 4
       |>Seq.collect(fun n->g|>Seq.map(fun i->{n with Gz=i}))|>Seq.filter(fun n-> fn n.Nz N.Swedish   n.Gz G.Dog)             //# 3
       |>Seq.collect(fun n->e|>Seq.map(fun i->{n with Ez=i}))|>Seq.filter(fun n-> fn n.Nz N.English   n.Ez E.Red   &&         //# 2
                                                                                  fn n.Ez E.Green     n.Iz I.Coffee&&         //# 6
                                                                                  fg n.Nz N.Norwegian n.Ez E.Blue)            //#15
       |>Seq.collect(fun n->l|>Seq.map(fun i->{n with Lz=i}))|>Seq.tryFind(fun n->fn n.Lz L.PallMall  n.Gz G.Birds &&         //# 7
                                                                                  fg n.Lz L.Blend     n.Gz G.Cats  &&         //#11
                                                                                  fn n.Lz L.Prince    n.Nz N.German&&         //#14
                                                                                  fg n.Lz L.Blend     n.Iz I.Water &&         //#16
                                                                                  fg n.Lz L.Dunhill   n.Gz G.Horse &&         //#12
                                                                                  fn n.Lz L.Dunhill   n.Ez E.Yellow&&         //# 8
                                                                                  fn n.Iz I.Beer      n.Lz L.BlueMaster) with //#13
|Some(nn) -> nn.Gz |> Array.iteri(fun n g -> if (g = G.Zebra) then printfn "\nThe man who owns a zebra is %A\n" nn.Nz.[n]); printfn "%A" nn
|None    -> printfn "No solution found"
