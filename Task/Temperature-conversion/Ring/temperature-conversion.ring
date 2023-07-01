k = 21.0 c = 0 r = 0 f = 0
convertTemp(k)
see "Kelvin : " + k + nl +
"Celcius : " + c + nl +
"Rankine : " + r + nl +
"Fahrenheit : " + f + nl

func convertTemp k
     c = k - 273.15
     r = k * 1.8
     f = r - 459.67
