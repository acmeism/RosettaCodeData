type Stack<'a> //'//(workaround for syntax highlighting problem)
  (?items) =
  let items = defaultArg items []

  member x.Push(A) = Stack(A::items)

  member x.Pop() =
    match items with
      | x::xr ->  (x, Stack(xr))
      | [] -> failwith "Stack is empty."

  member x.IsEmpty() = items = []

// example usage
let anEmptyStack = Stack<int>()
let stack2 = anEmptyStack.Push(42)
printfn "%A" (stack2.IsEmpty())
let (x, stack3) = stack2.Pop()
printfn "%d" x
printfn "%A" (stack3.IsEmpty())
