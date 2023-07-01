open System

let hamburgers = 4000000000000000M
let hamburgerPrice = 5.50M
let milkshakes = 2M
let milkshakePrice = 2.86M
let taxRate = 0.0765M

let total = hamburgers * hamburgerPrice + milkshakes * milkshakePrice
let tax = total * taxRate
let totalWithTax = total + tax

printfn "Total before tax:\t$%M" <| Math.Round (total, 2)
printfn "             Tax:\t$%M" <| Math.Round (tax, 2)
printfn "           Total:\t$%M" <| Math.Round (totalWithTax, 2)
