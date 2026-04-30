// Call an object method. Nigel Galloway: April 17th., 2026
type myClass(g:string)=
  let n=g
  static member whoAreUstat n=printfn "A static member of myClass %s" n
  member this.whoAreUins=printfn "An instance member of myClass %s" n

myClass.whoAreUstat "Nigel"
(myClass "Nigel").whoAreUins
