function convert_temp(k)
    local c = k - 273.15
    local r = k * 1.8
    local f = r - 459.67
    return k, c, r, f
end

print(string.format([[
Kelvin: %.2f K
Celcius: %.2f °C
Rankine: %.2f °R
Fahrenheit: %.2f °F
]],convert_temp(21.0)))
