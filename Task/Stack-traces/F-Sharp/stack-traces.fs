open System.Diagnostics

type myClass() =
    member this.inner() = printfn "%A" (new StackTrace())
    member this.middle() = this.inner()
    member this.outer() = this.middle()

[<EntryPoint>]
let main args =
    let that = new myClass()
    that.outer()
    0
