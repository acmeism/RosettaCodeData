open System.Collections.Generic

let first (l: LinkedList<char>) = l.First
let last (l: LinkedList<char>) = l.Last

let next (l: LinkedListNode<char>) = l.Next
let prev (l: LinkedListNode<char>) = l.Previous

let traverse g f (ls: LinkedList<char>) =
    let rec traverse (l: LinkedListNode<char>) =
        match l with
        | null -> ()
        | _ ->
            printf "%A" l.Value
            traverse (f l)
    traverse (g ls)

let traverseForward = traverse first next
let traverseBackward = traverse last prev

let cs = LinkedList(['a'..'z'])

traverseForward cs
printfn ""
traverseBackward cs
