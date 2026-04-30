function xmlquote(sequence s)
    sequence r
    r = ""
    for i = 1 to length(s) do
        if s[i] = '<' then
            r &= "&lt;"
        elsif s[i] = '>' then
            r &= "&gt;"
        elsif s[i] = '&' then
            r &= "&amp;"
        elsif s[i] = '"' then
            r &= "&quot;"
        elsif s[i] = '\'' then
            r &= "&apos;"
        else
            r &= s[i]
        end if
    end for
    return r
end function

constant CharacterRemarks = {
    {"April", "Bubbly: I'm > Tam and <= Emily"},
    {"Tam O'Shanter", "Burns: \"When chapman billies leave the street ...\""},
    {"Emily", "Short & shrift"}
}

puts(1,"<CharacterRemarks>\n")
for i = 1 to length(CharacterRemarks) do
    printf(1,"  <CharacterName=\"%s\">",{xmlquote(CharacterRemarks[i][1])})
    puts(1,xmlquote(CharacterRemarks[i][2]))
    puts(1,"</Character>\n")
end for
puts(1,"</CharacterRemarks>\n")
