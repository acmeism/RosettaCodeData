open System

let removeEmptyLists lists = lists |> List.filter (not << List.isEmpty)
let flip f x y = f y x

let rec transpose = function
    | []    -> []
    | lists -> (List.map List.head lists) :: transpose(removeEmptyLists (List.map List.tail lists))

// Using the backward composition operator "<<" (equivalent to Haskells ".") ...
let beadSort = List.map List.sum << transpose << transpose << List.map (flip List.replicate 1)

// Using the forward composition operator ">>" ...
let beadSort2 = List.map (flip List.replicate 1) >> transpose >> transpose >> List.map List.sum
