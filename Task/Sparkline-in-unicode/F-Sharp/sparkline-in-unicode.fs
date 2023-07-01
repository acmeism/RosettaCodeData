open System
open System.Globalization
open System.Text.RegularExpressions

let bars = Array.map Char.ToString ("▁▂▃▄▅▆▇█".ToCharArray())

while true do
    printf "Numbers separated by anything: "
    let numbers =
        [for x in Regex.Matches(Console.ReadLine(), @"-?\d+(?:\.\d*)?") do yield x.Value]
        |> List.map (fun x -> Double.Parse(x, CultureInfo.InvariantCulture))
    if numbers.Length = 0 then System.Environment.Exit(0)
    if numbers.Length = 1 then
        printfn "A sparkline for 1 value is not very useful... ignoring entry"
    else
        let min, max = List.min numbers, List.max numbers
        printfn "min: %5f; max: %5f" min max
        let barsCount = float (bars.GetUpperBound(0))
        numbers
        |> List.map (fun x -> bars.[int ((x - min)/(max - min) * barsCount)])
        |> String.Concat
        |> printfn "%s"
