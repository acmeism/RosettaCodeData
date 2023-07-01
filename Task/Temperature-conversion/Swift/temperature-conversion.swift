func KtoC(kelvin : Double)->Double{

    return kelvin-273.15
}

func KtoF(kelvin : Double)->Double{

    return ((kelvin-273.15)*1.8)+32
}

func KtoR(kelvin : Double)->Double{

    return ((kelvin-273.15)*1.8)+491.67
}

var k// input
print("\(k) Kelvin")
var c=KtoC(kelvin : k)
print("\(c) Celsius")
var f=KtoF(kelvin : k)
print("\(f) Fahrenheit")
var r=KtoR(kelvin : k)
print("\(r) Rankine")
