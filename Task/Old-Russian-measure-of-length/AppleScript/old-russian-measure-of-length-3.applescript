use AppleScript version "2.5" -- macOS 10.12 (Sierra) or later. Not 10.11 (El Capitan).
use framework "Foundation"
use scripting additions

property |⌘| : current application

-- Return a custom NSUnit with a linear converter.
on customNSUnit(unitClassName, symbol, coefficient, |offset|)
    set converter to |⌘|'s class "NSUnitConverterLinear"'s alloc()'s initWithCoefficient:(coefficient) |constant|:(|offset|)
    return |⌘|'s class unitClassName's alloc()'s initWithSymbol:(symbol) converter:(converter)
end customNSUnit

on program(inputNumber, inputUnitName)
    -- The task description only specifies these seven units, but more can be added if wished.
    -- The base unit of the NSUnitLength class is 'meters'.
    set unitRecords to {{|name|:"metre", NSUnit:|⌘|'s class "NSUnitLength"'s |meters|()}, ¬
        {|name|:"centimetre", NSUnit:|⌘|'s class "NSUnitLength"'s |centimeters|()}, ¬
        {|name|:"kilometre", NSUnit:|⌘|'s class "NSUnitLength"'s |kilometers|()}, ¬
        {|name|:"vershok", NSUnit:customNSUnit("NSUnitLength", "vershok", 0.04445, 0)}, ¬
        {|name|:"arshin", NSUnit:customNSUnit("NSUnitLength", "arshin", 0.7112, 0)}, ¬
        {|name|:"sazhen", NSUnit:customNSUnit("NSUnitLength", "sazhen", 2.1336, 0)}, ¬
        {|name|:"versta", NSUnit:customNSUnit("NSUnitLength", "versta", 1066.8, 0)}}

    -- Massage the given input unit name if necessary.
    if (inputUnitName ends with "s") then set inputUnitName to text 1 thru -2 of inputUnitName
    if (inputUnitName ends with "meter") then set inputUnitName to (text 1 thru -3 of inputUnitName) & "re"

    -- Get the record with the input unit name from 'unitRecords'.
    set filter to |⌘|'s class "NSPredicate"'s predicateWithFormat_("name == %@", inputUnitName)
    set filteredList to ((|⌘|'s class "NSArray"'s arrayWithArray:(unitRecords))'s filteredArrayUsingPredicate:(filter)) as list
    if (filteredList is {}) then error "Unrecognised unit name: " & inputUnitName
    set inputUnitRecord to beginning of filteredList

    -- Set up an NSMeasurement using the input number and the NSUnit from the record.
    set inputMeasurement to |⌘|'s class "NSMeasurement"'s alloc()'s ¬
        initWithDoubleValue:(inputNumber) unit:(inputUnitRecord's NSUnit)

    -- Get equivalent NSMeasurements in all the specified units and format them as text using an NSMeasurementFormatter
    -- configured to use the measurements' own units instead of local equivalents and, in the case of the three preset units,
    -- to include the full words, localised and pluralised as appropriate, instead of the symbols "m", "cm", or "km".
    set output to {}
    set measurementFormatter to |⌘|'s class "NSMeasurementFormatter"'s new()
    tell measurementFormatter to setUnitOptions:(|⌘|'s NSMeasurementFormatterUnitOptionsProvidedUnit)
    tell measurementFormatter to setUnitStyle:(|⌘|'s NSFormattingUnitStyleLong)
    repeat with thisRecord in unitRecords
        set outputMeasurement to (inputMeasurement's measurementByConvertingToUnit:(thisRecord's NSUnit))
        set formattedMeasurement to (measurementFormatter's stringFromMeasurement:(outputMeasurement)) as text
        if not ((outputMeasurement's doubleValue() is 1) or (thisRecord's |name| ends with "metre")) then ¬
            set formattedMeasurement to formattedMeasurement & "s"
        set end of output to formattedMeasurement
    end repeat

    return output -- {formatted text, … }
end program

on demo()
    considering numeric strings
        if ((system info)'s system version < "10.12") then ¬
            error "El Capitan doesn't support the Foundation framework's Units and Measurement system"
    end considering
    set output to {}
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ";  "
    repeat with input in {{1, "kilometre"}, {1, "versta"}}
        set {inputNumber, inputUnitName} to input
        set end of output to (inputNumber as text) & space & inputUnitName & " is:"
        set end of output to program(inputNumber, inputUnitName) as text
    end repeat
    set AppleScript's text item delimiters to linefeed
    set output to output as text
    set AppleScript's text item delimiters to astid

    return output
end demo

return demo()
