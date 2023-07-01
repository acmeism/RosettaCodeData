let insertionSort collection =

    // Inserts an element into its correct place in a sorted collection
    let rec sinsert element collection =
        match element, collection with
        | x, [] -> [x]
        | x, y::ys when x < y -> x::y::ys
        | x, y::ys -> y :: (ys |> sinsert x)

    // Performs Insertion Sort
    let rec isort acc collection =
        match collection, acc with
        | [], _ -> acc
        | x::xs, ys -> xs |> isort (sinsert x ys)
    collection |> isort []
