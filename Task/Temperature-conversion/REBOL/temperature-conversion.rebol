Rebol [
    title: "Rosetta code: Temperature conversion"
    file:  %Temperature_conversion.r3
    url:   https://rosettacode.org/wiki/Temperature_conversion
]

convert-kelvins: function [k [integer! decimal!]][
    make object! [
        kelvins:     k
        celsius:     k - 273.15
        fahrenheit: (k * 9 / 5.0) - 459.67
        rankine:     k * 9 / 5.0
    ]
]

print convert-kelvins 100
