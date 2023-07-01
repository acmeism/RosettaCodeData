// Imperative Solution
while true do
    printfn "SPAM"

// Functional solution
let rec forever () : unit =
    printfn "SPAM"
    forever ()
