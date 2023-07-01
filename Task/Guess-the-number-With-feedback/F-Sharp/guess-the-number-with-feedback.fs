open System

[<EntryPoint>]
let main argv =
    let aim =
        let from = 1
        let upto = 100
        let rnd = System.Random()
        Console.WriteLine("Hi, you have to guess a number between {0} and  {1}",from,upto)
        rnd.Next(from,upto)

    let mutable correct = false
    while not correct do

        let guess =
            Console.WriteLine("Please enter your guess:")
            match System.Int32.TryParse(Console.ReadLine()) with
            | true, number -> Some(number)
            | false,_ -> None

        match guess with
            | Some(number) ->
                match number with
                    | number when number > aim ->   Console.WriteLine("You guessed to high!")
                    | number when number < aim ->   Console.WriteLine("You guessed to low!")
                    | _                        ->   Console.WriteLine("You guessed right!")
                                                    correct <- true
            | None -> Console.WriteLine("Error: You didn't entered a parsable number!")

    0
