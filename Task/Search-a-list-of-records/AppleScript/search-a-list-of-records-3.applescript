use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

-- Return the zero-based index of the first dictionary in an array which matches a given criterion or criteria.
on indexOfFirstDictionaryInArray:theArray |whose|:predicateText
    set filter to current application's class "NSPredicate"'s predicateWithFormat:(predicateText)
    set filteredArray to theArray's filteredArrayUsingPredicate:(filter)
    if ((count filteredArray) > 0) then
        return (theArray's indexOfObjectIdenticalTo:(filteredArray's firstObject())) as integer
    else
        return missing value -- No match.
    end if
end indexOfFirstDictionaryInArray:|whose|:

on run
    local listOfRecords, arrayOfDictionaries, result1, result2, result3

    set listOfRecords to {¬
        {|name|:"Lagos", population:21.0}, ¬
        {|name|:"Cairo", population:15.2}, ¬
        {|name|:"Kinshasa-Brazzaville", population:11.3}, ¬
        {|name|:"Greater Johannesburg", population:7.55}, ¬
        {|name|:"Mogadishu", population:5.85}, ¬
        {|name|:"Khartoum-Omdurman", population:4.98}, ¬
        {|name|:"Dar Es Salaam", population:4.7}, ¬
        {|name|:"Alexandria", population:4.58}, ¬
        {|name|:"Abidjan", population:4.4}, ¬
        {|name|:"Casablanca", population:3.98}}

    set arrayOfDictionaries to current application's class "NSArray"'s arrayWithArray:(listOfRecords)

    set result1 to my indexOfFirstDictionaryInArray:arrayOfDictionaries |whose|:"name == 'Dar Es Salaam'"

    set result2 to my indexOfFirstDictionaryInArray:arrayOfDictionaries |whose|:"population < 5"
    if (result2 is not missing value) then set result2 to |name| of item (result2 + 1) of listOfRecords

    set result3 to my indexOfFirstDictionaryInArray:arrayOfDictionaries |whose|:"name BEGINSWITH 'A'"
    if (result3 is not missing value) then set result3 to population of item (result3 + 1) of listOfRecords

    return {result1, result2, result3} --> {6, "Khartoum-Omdurman", 4.58}
end run
