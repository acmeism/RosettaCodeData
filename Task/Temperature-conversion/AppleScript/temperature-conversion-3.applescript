on convertFromKelvin(kelvinValue)
    set kelvinMeasurement to kelvinValue as degrees Kelvin

    set celsiusValue to kelvinMeasurement as degrees Celsius as number
    set fahrenheitValue to kelvinMeasurement as degrees Fahrenheit as number
    set rankineValue to kelvinValue * 9 / 5

    return ("K" & tab & (kelvinValue as real)) & ¬
        (linefeed & "C" & tab & celsiusValue) & ¬
        (linefeed & "F" & tab & fahrenheitValue) & ¬
        (linefeed & "R" & tab & rankineValue)
end convertFromKelvin

convertFromKelvin(21)
