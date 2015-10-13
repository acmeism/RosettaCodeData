program TemperatureConvert;

type
    TemperatureType = (C, F, K, R);

var
    kelvin: real;

    function ConvertTemperature(temperature: real; fromType, toType: TemperatureType): real;

    var
        initial, result: real;

    begin
        (* We are going to first convert whatever we're given into Celsius.
           Then we'll convert that into whatever we're asked to convert into.
           Maybe not the most efficient way to do this, but easy to understand
           and should make it easier to add any additional temperature units. *)
        if fromType <> toType then
            begin
                case fromType of (* first convert the temperature into Celsius *)
                    C:
                        initial := temperature;
                    F:
                        initial := (temperature - 32) / 1.8;
                    K:
                        initial := temperature - 273.15;
                    R:
                        initial := (temperature - 491.67) / 1.8;
                end;
                case toType of (* now convert from Celsius into whatever degree type was asked for *)
                    C:
                        result := initial;
                    F:
                        result := (initial * 1.8) + 32;
                    K:
                        result := initial + 273.15;
                    R:
                        result := (initial * 1.8) + 491.67;
                end;
            end
        else (* no point doing all that math if we're asked to convert from and to the same type *)
            result := temperature;
        ConvertTemperature := result;
    end;

begin
    write('Temperature to convert (in kelvins): ');
    readln(kelvin);
    writeln(kelvin : 3 : 2, ' in kelvins is ');
    writeln('    ', ConvertTemperature(kelvin, K, C) : 3 : 2, ' in degrees Celsius.');
    writeln('    ', ConvertTemperature(kelvin, K, F) : 3 : 2, ' in degrees Fahrenheit.');
    writeln('    ', ConvertTemperature(kelvin, K, R) : 3 : 2, ' in degrees Rankine.');
end.
