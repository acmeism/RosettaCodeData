$ jq -n -r -f Strip_control_codes_and_extended_characters.jq
string | strip_control_codes
 => string of ☺☻♥♦⌂, may include control characters such as null() and other ilk.§►↔◄Rødgrød med fløde
string | strip_extended_characters
 => string of , may include control characters such as null() and other ilk.Rdgrd med flde
