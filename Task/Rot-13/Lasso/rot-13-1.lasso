// Extend the string type

define string->rot13 => {
    local(
        rot13 = bytes,
        i, a, b
    )

    with char in .eachCharacter
    let int = #char->integer
    do {
        // We only modify these ranges, set range if we should modify
        #int >= 65 and #int < 91  ? local(a=65,b=91)  |
        #int >= 97 and #int < 123 ? local(a=97,b=123) | local(a=0,b=0)

        if(#a && #b) => {
            #i = (#int+13) % #b         // loop back if past ceiling (#b)
            #i += #a * (1 - #i / #a)    // offset if below floor (#a)
            #rot13->import8bits(#i)     // import the new character
        else
            #rot13->append(#char)       // just append the character
        }
    }

    return #rot13->asstring
}
