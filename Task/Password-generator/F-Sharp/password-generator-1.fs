// A function to generate passwords of a given length. Nigel Galloway: May 2nd., 2018
let N = (set)"qwertyuiopasdfghjklzxcvbnm"
let I = (set)"QWERTYUIOPASDFGHJKLZXCVBNM"
let G = (set)"7894561230"
let E = (set)"""!"#$%&'()*+,-./:;<=>?@[]^_{|}~[||]"""
let L = Array.ofSeq (Set.unionMany [N;I;G;E])
let y = System.Random 23
let pWords n=
  let fN n = not (Set.isEmpty (Set.intersect N n )||Set.isEmpty (Set.intersect I n )||Set.isEmpty (Set.intersect G n )||Set.isEmpty (Set.intersect E n ))
  Seq.initInfinite(fun _->(set)(List.init n (fun _->L.[y.Next()%(Array.length L)])))|>Seq.filter fN|>Seq.map(Set.toArray >> System.String)
