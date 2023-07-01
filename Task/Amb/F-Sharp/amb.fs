// define the List "workflow" (monad)
type ListBuilder() =
   member o.Bind( lst, f ) = List.concat( List.map (fun x -> f x) lst )
   member o.Return( x ) = [x]
   member o.Zero() = []

let list = ListBuilder()

let amb = id

// last element of a sequence
let last s = Seq.nth ((Seq.length s) - 1) s

// is the last element of left the same as the first element of right?
let joins left right = last left = Seq.head right

let example = list { let! w1 = amb ["the"; "that"; "a"]
                     let! w2 = amb ["frog"; "elephant"; "thing"]
                     let! w3 = amb ["walked"; "treaded"; "grows"]
                     let! w4 = amb ["slowly"; "quickly"]
                     if joins w1 w2 &&
                        joins w2 w3 &&
                        joins w3 w4
                     then
                        return String.concat " " [w1; w2; w3; w4]
                   }

printfn "%s" (List.head example)
