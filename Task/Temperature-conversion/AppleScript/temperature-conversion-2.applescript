on convertFromKelvin(kelvinValue)
    return ("K" & tab & (kelvinValue as real)) & ¬
        (linefeed & "C" & tab & (kelvinValue - 273.15)) & ¬
        (linefeed & "F" & tab & ((kelvinValue - 273.15) * 9 / 5 + 32)) & ¬
        (linefeed & "R" & tab & (kelvinValue * 9 / 5))
end convertFromKelvin

convertFromKelvin(21)
