open System

let multTable () =
    Console.Write (" X".PadRight (4))
    for i = 1 to 12 do Console.Write ((i.ToString "####").PadLeft 4)
    Console.Write "\n ___"
    for i = 1 to 12 do Console.Write " ___"
    Console.WriteLine ()
    for row = 1 to 12 do
        Console.Write (row.ToString("###").PadLeft(3).PadRight(4))
        for col = 1 to 12 do
            if row <= col then Console.Write ((row * col).ToString("###").PadLeft(4))
            else
                Console.Write ("".PadLeft 4)
        Console.WriteLine ()
    Console.WriteLine ()
    Console.ReadKey () |> ignore

multTable ()
