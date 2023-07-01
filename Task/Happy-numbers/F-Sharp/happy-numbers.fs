open System.Collections.Generic
open Microsoft.FSharp.Collections

let answer =
    let sqr x = x*x                                                 // Classic square definition
    let rec AddDigitSquare n =
        match n with
        | 0 -> 0                                                    // Sum of squares for 0 is 0
        | _ -> sqr(n % 10) + (AddDigitSquare (n / 10))              // otherwise add square of bottom digit to recursive call
    let dict = new Dictionary<int, bool>()                          // Dictionary to memoize values
    let IsHappy n =
        if dict.ContainsKey(n) then                                 // If we've already discovered it
            dict.[n]                                                // Return previously discovered value
        else
            let cycle = new HashSet<_>(HashIdentity.Structural)     // Set to keep cycle values in
            let rec isHappyLoop n =
                if cycle.Contains n then n = 1                      // If there's a loop, return true if it's 1
                else
                    cycle.Add n |> ignore                           // else add this value to the cycle
                    isHappyLoop (AddDigitSquare n)                  // and check the next number in the cycle
            let f = isHappyLoop n                                   // Keep track of whether we're happy or not
            cycle |> Seq.iter (fun i -> dict.[i] <- f)              // and apply it to all the values in the cycle
            f                                                       // Return the boolean

    1                                                               // Starting with 1,
    |> Seq.unfold (fun i -> Some (i, i + 1))                        // make an infinite sequence of consecutive integers
    |> Seq.filter IsHappy                                           // Keep only the happy ones
    |> Seq.truncate 8                                               // Stop when we've found 8
    |> Seq.iter (Printf.printf "%d\n")				    // Print results
