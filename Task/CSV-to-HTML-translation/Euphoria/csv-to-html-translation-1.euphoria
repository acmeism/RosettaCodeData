constant input = "Character,Speech\n" &
    "The multitude,The messiah! Show us the messiah!\n" &
    "Brians mother,<angry>Now you listen here! He's not the messiah; " &
        "he's a very naughty boy! Now go away!</angry>\n" &
    "The multitude,Who are you?\n" &
    "Brians mother,I'm his mother; that's who!\n" &
    "The multitude,Behold his mother! Behold his mother!"

puts(1,"<table>\n<tr><td>")
for i = 1 to length(input) do
    switch input[i] do
        case '\n' then puts(1,"</td></tr>\n<tr><td>")
        case ','  then puts(1,"</td><td>")
        case '<'  then puts(1,"&lt;")
        case '>'  then puts(1,"&gt;")
        case '&'  then puts(1,"&amp;")
        case else puts(1,input[i])
    end switch
end for
puts(1,"</td></tr>\n</table>")
