use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"
use framework "AppKit"

on morseCode(msg)
    script morse
        -- Unit duration in seconds and sounds used.
        property units : 0.075
        property morseSound : current application's class "NSSound"'s soundNamed:("Glass")
        property unknownCharacterSound : current application's class "NSSound"'s soundNamed:("Frog")
        -- Unicode IDs of in-range but uncatered-for punctuation characters.
        property unrecognisedPunctuation : {35, 37, 42, 60, 62, 91, 92, 93, 94}
        -- Dits and dahs for recognised characters, in units.
        property letters : {{1, 3}, {3, 1, 1, 1}, {3, 1, 3, 1}, {3, 1, 1}, {1}, {1, 1, 3, 1}, {3, 3, 1}, {1, 1, 1, 1}, {1, 1}, ¬
            {1, 3, 3, 3}, {3, 1, 3}, {1, 3, 1, 1}, {3, 3}, {3, 1}, {3, 3, 3}, {1, 3, 3, 1}, {3, 3, 1, 3}, {1, 3, 1}, {1, 1, 1}, ¬
            {3}, {1, 1, 3}, {1, 1, 1, 3}, {1, 3, 3}, {3, 1, 1, 3}, {3, 1, 3, 3}, {3, 3, 1, 1}}
        property underscore : {1, 1, 3, 3, 1, 3}
        property digitsAndPunctuation : {{3, 3, 3, 3, 3}, {1, 3, 3, 3, 3}, {1, 1, 3, 3, 3}, {1, 1, 1, 3, 3}, ¬
            {1, 1, 1, 1, 3}, {1, 1, 1, 1, 1}, {3, 1, 1, 1, 1}, {3, 3, 1, 1, 1}, {3, 3, 3, 1, 1}, {3, 3, 3, 3, 1}, ¬
            {3, 3, 3, 1, 1, 1}, {3, 1, 3, 1, 3, 1}, missing value, {3, 1, 1, 1, 3}, missing value, ¬
            {1, 1, 3, 3, 1, 1}, {1, 3, 3, 1, 3, 1}}
        property |punctuation| : {{3, 1, 3, 1, 3, 3}, {1, 3, 1, 1, 3, 1}, missing value, {1, 1, 1, 3, 1, 1, 3}, missing value, ¬
            {1, 3, 1, 1, 1}, {1, 3, 3, 3, 3, 1}, {3, 1, 3, 3, 1}, {3, 1, 3, 3, 1, 3}, missing value, ¬
            {1, 3, 1, 3, 1}, {3, 3, 1, 1, 3, 3}, {3, 1, 1, 1, 1, 3}, {1, 3, 1, 3, 1, 3}, {3, 1, 1, 3, 1}}
        -- Unicode IDs of the message's characters.
        property UnicodeIDs : (id of msg) as list

        on sendCharacter(ditsAndDahs)
            repeat with ditOrDah in ditsAndDahs
                tell morseSound to play()
                delay (ditOrDah * units)
                tell morseSound to stop()
                delay (1 * units)
            end repeat
            delay (2 * units) -- Previous 1 unit + 2 units = 3 units between characters.
        end sendCharacter

        on sendMessage()
            -- Play an extremely short sound to ensure the sound system's awake for the first morse beep.
            tell morse to sendCharacter({0})
            -- Output the message.
            repeat with i from 1 to (count UnicodeIDs)
                set thisID to item i of my UnicodeIDs
                if ((thisID > 122) or (thisID < 32) or (thisID is in unrecognisedPunctuation)) then
                    -- Character not catered for. Play alternative sound.
                    tell unknownCharacterSound to play()
                    delay (3 * units)
                    tell unknownCharacterSound to stop()
                    delay (3 * units)
                else if ((thisID > 64) and ((thisID < 91) or (thisID > 96))) then -- English letter.
                    sendCharacter(item (thisID mod 32) of my letters)
                else if (thisID is 95) then -- Underscore.
                    sendCharacter(underscore)
                else if (thisID > 47) then -- Digit, colon, semicolon, equals, or question mark.
                    sendCharacter(item (thisID - 47) of my digitsAndPunctuation)
                else if (thisID > 32) then -- Other recognised punctuation.
                    sendCharacter(item (thisID - 32) of my |punctuation|)
                else -- Space.
                    delay (4 * units) -- Previous 3 units + 4 units = 7 units between "words".
                end if
            end repeat
        end sendMessage
    end script

    tell morse to sendMessage()
end morseCode

-- Test code:
morseCode("Coded in AppleScrip†.")
