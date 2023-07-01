// Define units of measure
[<Measure>] type k
[<Measure>] type f
[<Measure>] type c
[<Measure>] type r

// Define conversion functions
let kelvinToCelsius (t : float<k>) = ((float t) - 273.15) * 1.0<c>
let kelvinToFahrenheit (t : float<k>) = (((float t) * 1.8) - 459.67) * 1.0<f>
let kelvinToRankine (t : float<k>) = ((float t) * 1.8) * 1.0<r>

// Example code
let K = 21.0<k>
printfn "%A Kelvin is %A Celsius" K (kelvinToCelsius K)
printfn "%A Kelvin is %A Fahrenheit" K (kelvinToFahrenheit K)
printfn "%A Kelvin is %A Rankine" K (kelvinToRankine K)
