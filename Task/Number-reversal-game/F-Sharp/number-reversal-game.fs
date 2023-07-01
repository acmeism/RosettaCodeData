let rand = System.Random()

while true do
  let rec randomNums() =
    let xs = [|for i in 1..9 -> rand.Next(), i|] |> Array.sort |> Array.map snd
    if xs = Array.sort xs then randomNums() else xs

  let xs = randomNums()

  let suffix = function | 1 -> "st" | 2 -> "nd" | 3 -> "rd" | _ -> "th"

  let rec move i =
    printf "\n%A\n\nReverse how many digits from the left in your %i%s move? : " xs i (suffix i)
    let n = stdin.ReadLine() |> int
    Array.blit (Array.rev xs.[0..n-1]) 0 xs 0 n
    if xs <> Array.sort xs then
        move (i+1)
    else
        printfn "\nYou took %i moves to put the digits in order!\n" i

  move 1
