-- General purpose linear measurement converter.
on convertLinear(inputNumber, inputUnitRecord, outputUnitRecord)
    set {inputType, outputType} to {inputUnitRecord's type, outputUnitRecord's type}
    if (inputType is not outputType) then error "Unit type mismatch: " & inputType & ", " & outputType
    -- The |offset| values are only relevant to temperature conversions and default to zero.
    set inputUnit to inputUnitRecord & {|offset|:0}
    set outputUnit to outputUnitRecord & {|offset|:0}

    return (inputNumber - (inputUnit's |offset|)) * (inputUnit's coefficient) / (outputUnit's coefficient) ¬
        + (outputUnit's |offset|)
end convertLinear

on program(inputNumber, inputUnitName)
    -- The task description only specifies these seven units, but more can be added if wished.
    -- The coefficients are the equivalent lengths in metres.
    set unitRecords to {{|name|:"metre", type:"length", coefficient:1.0}, ¬
        {|name|:"centimetre", type:"length", coefficient:0.01}, {|name|:"kilometre", type:"length", coefficient:1000.0}, ¬
        {|name|:"vershok", type:"length", coefficient:0.04445}, {|name|:"arshin", type:"length", coefficient:0.7112}, ¬
        {|name|:"sazhen", type:"length", coefficient:2.1336}, {|name|:"versta", type:"length", coefficient:1066.8}}

    -- Massage the given input unit name if necessary.
    if (inputUnitName ends with "s") then set inputUnitName to text 1 thru -2 of inputUnitName
    if (inputUnitName ends with "meter") then set inputUnitName to (text 1 thru -3 of inputUnitName) & "re"

    -- Get the record with the input unit name from 'unitRecords'.
    set inputUnitRecord to missing value
    repeat with thisRecord in unitRecords
        if (thisRecord's |name| is inputUnitName) then
            set inputUnitRecord to thisRecord's contents
            exit repeat
        end if
    end repeat
    if (inputUnitRecord is missing value) then error "Unrecognised unit name: " & inputUnitName

    -- Guess the user's spelling preference from the short-date order configured on their machine.
    tell (current date) to set {Feb1, its day, its month, its year} to {it, 1, 2, 3333}
    set USSpelling to (Feb1's short date string's first word as integer is 2)

    -- Convert the input number to its equivalents in all the specified units, rounding to eight decimal
    -- places and getting integer values as AS integers where possible. Pair the results with the unit names.
    set output to {}
    repeat with thisRecord in unitRecords
        set outputNumber to convertLinear(inputNumber, inputUnitRecord, thisRecord)
        set outputNumber to outputNumber div 1 + ((outputNumber * 100000000 mod 100000000) as integer) / 100000000
        if (outputNumber mod 1 is 0) then set outputNumber to outputNumber div 1
        set outputUnitName to thisRecord's |name|
        if ((outputUnitName ends with "metre") and (USSpelling)) then ¬
            set outputUnitName to (text 1 thru -3 of outputUnitName) & "er"
        if (outputNumber is not 1) then set outputUnitName to outputUnitName & "s"
        set end of output to {outputNumber, outputUnitName}
    end repeat

    return output -- {{number, unit name}, … }
end program

on demo()
    set output to {}
    set astid to AppleScript's text item delimiters
    repeat with input in {{1, "kilometre"}, {1, "versta"}}
        set {inputNumber, inputUnitName} to input
        set end of output to (inputNumber as text) & space & inputUnitName & " is:"
        set conversions to program(inputNumber, inputUnitName)
        set AppleScript's text item delimiters to space
        repeat with thisConversion in conversions
            set thisConversion's contents to thisConversion as text
        end repeat
        set AppleScript's text item delimiters to ";  "
        set end of output to conversions as text
    end repeat
    set AppleScript's text item delimiters to linefeed
    set output to output as text
    set AppleScript's text item delimiters to astid

    return output
end demo

return demo()
