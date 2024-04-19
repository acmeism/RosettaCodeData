convKelvin(Temp) :-
    Kelvin is Temp,
    Celsius is Temp - 273.15,
    Fahrenheit is (Temp - 273.15) * 1.8 + 32.0,
    Rankine is (Temp - 273.15) * 1.8 + 32.0 + 459.67,
    format('~f degrees Kelvin~n', [Kelvin]),
    format('~f degrees Celsius~n', [Celsius]),
    format('~f degrees Fahrenheit~n', [Fahrenheit]),
    format('~f degrees Rankine~n', [Rankine]).

test :-
    convKelvin(0.0),
    nl,
    convKelvin(21.0).
