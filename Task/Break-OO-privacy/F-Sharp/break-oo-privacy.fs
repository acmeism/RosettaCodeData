open System
open System.Reflection

type MyClass() =
    let answer = 42
    member this.GetAnswer
        with get() = answer


[<EntryPoint>]
let main argv =
    let myInstance = MyClass()
    let fieldInfo = myInstance.GetType().GetField("answer", BindingFlags.NonPublic ||| BindingFlags.Instance)
    let answer = fieldInfo.GetValue(myInstance)
    printfn "%s = %A" (answer.GetType().ToString()) answer
    0
