use AppleScript version "2.5" -- macOS 10.12 (Sierra) or later
use framework "Foundation"

on convertFromKelvin(kelvinValue)
    set |⌘| to current application

    -- Set up an NSMeasurement object representing the given number of Kelvin units.
    set kelvinUnit to |⌘|'s class "NSUnitTemperature"'s kelvin()
    set kelvinMeasurement to |⌘|'s class "NSMeasurement"'s alloc()'s initWithDoubleValue:(kelvinValue) unit:(kelvinUnit)

    -- Get value of the same measurement in each of the other "units" in turn.
    set celsiusUnit to |⌘|'s class "NSUnitTemperature"'s celsius()
    set celsiusMeasurement to kelvinMeasurement's measurementByConvertingToUnit:(celsiusUnit)
    set celsiusValue to celsiusMeasurement's doubleValue()

    set fahrenheitUnit to |⌘|'s class "NSUnitTemperature"'s fahrenheit()
    set fahrenheitMeasurement to kelvinMeasurement's measurementByConvertingToUnit:(fahrenheitUnit)
    set fahrenheitValue to fahrenheitMeasurement's doubleValue()

    -- There's no predefined unit for Rankine (as at macOS 10.14 Mojave), but custom units are easy to define.
    -- A unit's linear 'converter' must contain the unit's size and zero offset relative to those of its class's "base unit"
    -- which for temperatures is the 'kelvin' unit.
    set rankineConverter to |⌘|'s class "NSUnitConverterLinear"'s alloc()'s initWithCoefficient:(5 / 9) |constant|:(0)
    set rankineUnit to |⌘|'s class "NSUnitTemperature"'s alloc()'s initWithSymbol:("°R") converter:(rankineConverter)
    set rankineMeasurement to kelvinMeasurement's measurementByConvertingToUnit:(rankineUnit)
    set rankineValue to rankineMeasurement's doubleValue()

    return ("K" & tab & (kelvinValue as real)) & ¬
        (linefeed & "C" & tab & celsiusValue) & ¬
        (linefeed & "F" & tab & fahrenheitValue) & ¬
        (linefeed & "R" & tab & rankineValue)
end convertFromKelvin

convertFromKelvin(21)
