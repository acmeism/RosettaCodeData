on countryCodes()
    -- A list of 34 lists. The nth list (1-indexed) contains country codes for countries having n-character IBANS.
    return {{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {"NO"}, {"BE"}, ¬
        {}, {"DK", "FO", "FI", "GL", "NL"}, {"MK", "SI"}, {"AT", "BA", "EE", "KZ", "XK", "LT", "LU"}, ¬
        {"HR", "LV", "LI", "CH"}, {"BH", "BG", "CR", "GE", "DE", "IE", "ME", "RS", "GB", "VA"}, ¬
        {"TL", "GI", "IQ", "IL", "AE"}, {"AD", "CZ", "MD", "PK", "RO", "SA", "SK", "ES", "SE", "TN", "VG"}, ¬
        {"PT", "ST"}, {"IS", "TR"}, {"FR", "GR", "IT", "MR", "MC", "SM"}, ¬
        {"AL", "AZ", "BY", "CY", "DO", "SV", "GT", "HU", "LB", "PL"}, {"BR", "EG", "PS", "QA", "UA"}, ¬
        {"JO", "KW", "MU"}, {"MT", "SC"}, {"LC"}, {}, {}}
end countryCodes

on validateIBAN(iban)
    -- Remove any spaces.
    if (iban contains space) then set iban to replaceText(iban, space, "")
    considering diacriticals but ignoring case
        -- Check the length both overall and against the presumed country code.
        set characterCount to (count iban)
        if ((characterCount > 34) or (text 1 thru 2 of iban is not in item characterCount of countryCodes())) then return false
        -- Move the first four characters to the end.
        set iban to text 5 thru -1 of iban & (text 1 thru 4 of iban)
        -- Replace any unadorned Latin letters with the appropriate number characters ("A" = "11" … "Z" = "35").
        repeat with letter in "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            if (iban contains letter) then set iban to replaceText(iban, letter, ((letter's id) mod 32 + 9) as text)
        end repeat
    end considering
    -- Check that what's left only contains digit characters.
    if (replaceText(iban, characters of "0123456789", "") is not "") then return false
    -- Calculate the mod-97 remainder.
    set characterCount to (count iban)
    set c to (characterCount - 1) mod 7 + 1
    set mod97 to (text 1 thru c of iban) mod 97
    repeat with c from (c + 1) to characterCount by 7
        set mod97 to (mod97 * 10000000 + (text c thru (c + 6) of iban)) mod 97
    end repeat

    return (mod97 = 1)
end validateIBAN

on replaceText(txt, searchStr, replaceText)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to searchStr
    set txt to txt's text items
    set AppleScript's text item delimiters to replaceText
    set txt to txt as text
    set AppleScript's text item delimiters to astid
    return txt
end replaceText

-- Test code (IBANs borrowed from other solutions on this page.):
local testIBANs, output, thisIBAN, astid

set testIBANs to {"GB82 WEST 1234 5698 7654 32", "gb82 west 1234 5698 7654 32", "GB82 TEST 1234 5698 7654 32", ¬
    "SA03 8000 0000 6080 1016 7519", "ZZ12 3456 7890 1234 5678 12", "IL62 0108 0000 0009 9999 999"}
set output to {}
repeat with thisIBAN in testIBANs
    set end of output to thisIBAN & item ((validateIBAN(thisIBAN) as integer) + 1) of {":  invalid", ":  valid"}
end repeat
set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to linefeed
set output to output as text
set AppleScript's text item delimiters to astid
return output
