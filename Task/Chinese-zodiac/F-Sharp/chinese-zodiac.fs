open System

let animals = ["Rat";"Ox";"Tiger";"Rabbit";"Dragon";"Snake";"Horse";"Goat";"Monkey";"Rooster";"Dog";"Pig"]
let elements = ["Wood";"Fire";"Earth";"Metal";"Water"]
let years = [1935;1938;1968;1972;1976;1984;1985;2017]

let getZodiac(year: int) =
    let animal = animals.Item((year-4)%12)
    let element = elements.Item(((year-4)%10)/2)
    let yy = if year%2 = 0 then "(Yang)" else "(Yin)"

    String.Format("{0} is the year of the {1} {2} {3}", year, element, animal, yy)

[<EntryPoint>]
let main argv =
    let mutable string = ""
    for i in years do
        string <- getZodiac(i)
        printf "%s" string
        Console.ReadLine() |> ignore
    0 // return an integer exit code
