do  -- find words which consist of alternating vowels and consonants

    local function hasAlternateVowelsAndConsonants( word )
        local function isVowel( c )
            return c:match( "[AEIOUaeiou]" ) == c
        end
        local result = word:match( "^%a+$" ) == word
        if result then
            local expectVowel = isVowel( word:sub( 1, 1 ) )
            for wPos = 1, # word do
                if not result then break end
                result, expectVowel = expectVowel == isVowel( word:sub( wPos, wPos ) ), not expectVowel
            end
        end
        return result
    end

    local avcWords, maxLength = {}, 0
    for word in io.lines( "unixdict.txt" ) do
        if # word > 9 then
            if hasAlternateVowelsAndConsonants( word ) then
                if # word > maxLength then
                    maxLength = # word
                end
                avcWords[ # avcWords + 1 ] = word
            end
        end
    end
    local fmt = "  %" .. maxLength .. "s"
    for i, w in ipairs( avcWords ) do
        io.write( string.format( fmt .. ( i % 6 == 0 and "\n" or "" ), w ) )
    end
    io.write( "\n" .. # avcWords .. " words of alternating vowels and consonants found\n" )

end
