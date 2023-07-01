// Learn more about F# at http://fsharp.net

open System

//(degree measure)*Degrees => Radian measure
//(radian measure)/Degrees => Degree measure
let Degrees = Math.PI / 180.0

Console.Write("Enter latitude: ")
let latitude = Console.ReadLine() |> Double.Parse

Console.Write("Enter longitude: ")
let longitude = Console.ReadLine() |> Double.Parse

Console.Write("Enter legal meridian: ")
let meridian = Console.ReadLine() |> Double.Parse

let sineLatitude = Math.Sin(latitude * Degrees)
Console.WriteLine()
Console.WriteLine("Sine of latitude: {0}",sineLatitude)
Console.WriteLine("Difference of Longitudes (given longitude - meridian): {0}",longitude-meridian)
Console.WriteLine()

printfn "Numbers from 6 AM to 6 PM: "
printfn "Hour\t\tSun hour angle\t Dial hour line angle"

for hour in -6..6 do
    let clockHour = if hour < 0 then String.Format("{0}AM",Math.Abs(hour)) else String.Format("{0}PM",hour)
    let shr = 15.0*(float)hour - (longitude - meridian)
    let dhla = Math.Atan(sineLatitude*Math.Tan(shr*Degrees))/Degrees;
    Console.WriteLine("{0}\t\t{1}\t\t{2:0.000}",clockHour,shr,dhla)
done

//To keep the console window open, can be omitted with block comment (" (* comment *) ")
Console.WriteLine("Press any key to continue...")
Console.ReadKey() |> ignore
