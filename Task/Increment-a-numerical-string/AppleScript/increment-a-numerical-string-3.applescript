use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

-- Using the machine's own locale setting. The numerical text must be compatible with this.
-- Params: Numerical text or NSString, AppleScript or Objective-C number or text equivalent.
on incrementNumericalString:str byAmount:increment
    set localeID to current application's class "NSLocale"'s currentLocale()'s localeIdentifier()
    return my incrementNumericalString:str byAmount:increment localeID:localeID
end incrementNumericalString:byAmount:

-- Including the locale ID as an additional parameter.
-- Params: As above plus locale ID (text or NSString).
on incrementNumericalString:str byAmount:increment localeID:localeID
    set |⌘| to current application
    set str to |⌘|'s class "NSString"'s stringWithString:(str)
    set locale to |⌘|'s class "NSLocale"'s localeWithLocaleIdentifier:(localeID)
    set decSeparator to locale's objectForKey:(|⌘|'s NSLocaleDecimalSeparator)
    set regex to |⌘|'s NSRegularExpressionSearch
    -- Use an NSNumberFormatter to generate the NSDecimalNumber objects for the math,
    -- as its number/string conversions are more flexible than NSDecimalNumber's own.
    tell |⌘|'s class "NSNumberFormatter"'s new()
        its setGeneratesDecimalNumbers:(true)
        its setLocale:(locale)
        set symbolRange to str's rangeOfString:("[Ee]| ?[x*] ?10 ?\\^ ?") options:(regex)
        if (symbolRange's |length|() > 0) then
            -- Catered-for exponent symbol in the input string. Set the output style to "scientific".
            its setNumberStyle:(|⌘|'s NSNumberFormatterScientificStyle)
            its setExponentSymbol:(str's substringWithRange:(symbolRange))
        else
            -- Straight numerical text, with or without separators as per the input and locale.
            its setNumberStyle:(|⌘|'s NSNumberFormatterDecimalStyle)
            set groupingSeparator to locale's objectForKey:(|⌘|'s NSLocaleGroupingSeparator)
            its setUsesGroupingSeparator:(str's containsString:(groupingSeparator))
            its setMinimumFractionDigits:(str's containsString:(decSeparator))
        end if
        -- Derive NSDecimalNumbers from the inputs, add together, convert the result back to NSString.
        set increment to (|⌘|'s class "NSArray"'s arrayWithArray:({increment}))'s firstObject()
        if ((increment's isKindOfClass:(|⌘|'s class "NSNumber")) as boolean) then ¬
            set increment to its stringFromNumber:(increment)
        set sum to (its numberFromString:(str))'s decimalNumberByAdding:(its numberFromString:(increment))
        set output to its stringFromNumber:(sum)
    end tell
    -- Adjustments for AppleScript norms the NSNumberFormatter may omit from scientific notation output:
    if (symbolRange's |length|() > 0) then
        -- If no decimal separator in the output mantissa, insert point zero or not to match the input style.
        if ((output's containsString:(decSeparator)) as boolean) then
        else if ((str's containsString:(decSeparator)) as boolean) then
            set output to output's stringByReplacingOccurrencesOfString:("(?<=^-?\\d)") ¬
                withString:((decSeparator as text) & "0") options:(regex) range:({0, output's |length|()})
        end if
        -- If no sign in an E-notation exponent, insert "+" or not ditto.
        if (((output's rangeOfString:("[Ee][+-]") options:(regex))'s |length|() > 0) as boolean) then
        else if (((str's rangeOfString:("[Ee][+-]") options:(regex))'s |length|() > 0) as boolean) then
            set output to output's stringByReplacingOccurrencesOfString:("(?<=[Ee])") ¬
                withString:("+") options:(regex) range:({0, output's |length|()})
        end if
    end if

    return output as text -- Return as AppleScript text.
end incrementNumericalString:byAmount:localeID:

return {¬
    (my incrementNumericalString:"12345" byAmount:1), ¬
    (my incrementNumericalString:"999,999,999,999,999" byAmount:5), ¬
    (my incrementNumericalString:"-1.234" byAmount:10 localeID:"en"), ¬
    (my incrementNumericalString:"-1,234E+1" byAmount:10 localeID:"fr_FR"), ¬
    (my incrementNumericalString:"-1.234 x 10^1" byAmount:"10") ¬
        }
