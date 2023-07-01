use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation" -- For the regex at the top of newUniverse()
use scripting additions

-- The characters to represent the live and dead cells.
property live : "■" -- character id 9632 (U+25A0).
property dead : space
-- Infinite universes are expensive to maintain, so only a local region of universe is represented here.
-- Its invisible border is a wall of "dead" cells one cell deep, lined with a two-cell buffer layer into which
-- objects nominally leaving the region can disappear without being seen to hit the wall or bouncing back.
property borderThickness : 3

on newUniverse(seed, {w, h})
    -- Replace every visible character in the seed text with "■" and every horizontal space with a space.
    set seed to current application's class "NSMutableString"'s stringWithString:(seed)
    set regex to current application's NSRegularExpressionSearch
    tell seed to replaceOccurrencesOfString:("\\S") withString:(live) options:(regex) range:({0, its |length|()})
    tell seed to replaceOccurrencesOfString:("\\h") withString:(dead) options:(regex) range:({0, its |length|()})
    -- Ensure the universe dimensions are at least equal to the number of lines and the length of the longest.
    set seedLines to paragraphs of (seed as text)
    set lineCount to (count seedLines)
    if (lineCount > h) then set h to lineCount
    set seedWidth to 0
    repeat with thisLine in seedLines
        set lineLength to (count thisLine)
        if (lineLength > seedWidth) then set seedWidth to lineLength
    end repeat
    if (seedWidth > w) then set w to seedWidth

    -- Get a new universe.
    script universe
        -- State lists. These will contain or be lists of 0s and 1s and will include the border cells.
        property newState : {}
        property previousState : {}
        property currentRow : {}
        property rowAbove : {}
        property rowBelow : {}
        property replacementRow : {}
        -- Equivalent text lists. These will only cover what's in the bounded region.
        property lineList : {}
        property characterGrid : {}
        property currentLineCharacters : {}
        -- Precalculated border cell indices.
        property rightInnerBuffer : borderThickness + w + 1
        property rightOuterBuffer : rightInnerBuffer + borderThickness - 2
        property bottomInnerBuffer : borderThickness + h + 1
        property bottomOuterBuffer : bottomInnerBuffer + borderThickness - 2
        -- Generation counter.
        property counter : 0
        -- Temporary lists used in the set-up.
        property rowTemplate : {}
        property lineCharacterTemplate : {}

        -- Built-in handlers. Both return text representing a universe state and
        -- a boolean indicating whether or not the state's the same as the previous one.
        on nextState()
            set astid to AppleScript's text item delimiters
            set AppleScript's text item delimiters to ""
            copy newState to previousState
            set currentRow to beginning of my previousState
            set rowBelow to item 2 of my previousState
            -- Check each occupiable cell in each occupiable row of the 'previousState' grid, including the buffer cells.
            -- If warranted by the number of live neighbours, edit the equivalent cell in 'newState' and,
            -- if within the region's bounds, change the corresponding text character too.
            repeat with r from 2 to bottomOuterBuffer
                set rowAbove to currentRow
                set currentRow to rowBelow
                set rowBelow to item (r + 1) of my previousState
                set replacementRow to item r of my newState
                set rowCrossesRegion to ((r comes after borderThickness) and (r comes before bottomInnerBuffer))
                if (rowCrossesRegion) then set currentLineCharacters to item (r - borderThickness) of my characterGrid
                set lineChanged to false
                repeat with c from 2 to rightOuterBuffer
                    set liveNeighbours to ¬
                        (item (c - 1) of my rowAbove) + (item c of my rowAbove) + (item (c + 1) of my rowAbove) + ¬
                        (item (c - 1) of my currentRow) + (item (c + 1) of my currentRow) + ¬
                        (item (c - 1) of my rowBelow) + (item c of my rowBelow) + (item (c + 1) of my rowBelow)
                    if (item c of my currentRow is 1) then
                        if ((liveNeighbours < 2) or (liveNeighbours > 3)) then
                            set item c of my replacementRow to 0
                            if ((c comes after borderThickness) and (c comes before rightInnerBuffer) and (rowCrossesRegion)) then
                                set item (c - borderThickness) of my currentLineCharacters to dead
                                set lineChanged to true
                            else if ((c is 3) or (c is rightOuterBuffer) or (r is 3) or (r is bottomOuterBuffer)) then
                                -- This is a fudge to dissolve "bombers" entering the buffer zone.
                                set item (c - 1) of my replacementRow to -1
                                set item c of item (r - 1) of my newState to -1
                            end if
                        end if
                    else if (liveNeighbours is 3) then
                        set item c of my replacementRow to 1
                        if ((c comes after borderThickness) and (c comes before rightInnerBuffer) and (rowCrossesRegion)) then
                            set item (c - borderThickness) of my currentLineCharacters to live
                            set lineChanged to true
                        end if
                    end if
                end repeat
                if (lineChanged) then set item (r - borderThickness) of my lineList to currentLineCharacters as text
            end repeat
            set AppleScript's text item delimiters to astid
            set counter to counter + 1
            set last item of my lineList to "Generation " & counter

            return currentState()
        end nextState

        on currentState()
            set noChanges to (newState = previousState)
            if (noChanges) then ¬
                set last item of my lineList to (last item of my lineList) & " (all dead, still lifes, or left the universe)"
            set astid to AppleScript's text item delimiters
            set AppleScript's text item delimiters to return
            set stateText to lineList as text
            set AppleScript's text item delimiters to astid

            return {stateText, noChanges}
        end currentState
    end script

    -- Set the universe's start conditions.
    -- Build a row template list containing w + 2 * borderThickness zeros
    -- and a line character template list containing w 'dead' characters.
    repeat (borderThickness * 2) times
        set end of universe's rowTemplate to 0
    end repeat
    repeat w times
        set end of universe's rowTemplate to 0
        set end of universe's lineCharacterTemplate to dead
    end repeat
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ""
    set blankLine to universe's lineCharacterTemplate as text

    -- Use the templates to populate lists representing the universe's conditions.
    -- Firstly the top border rows ('newState' list only).
    repeat borderThickness times
        copy universe's rowTemplate to end of universe's newState
    end repeat
    -- Then enough rows and text lines to centre the input roughly halfway down the grid.
    set headroom to (h - lineCount) div 2
    repeat headroom times
        copy universe's rowTemplate to end of universe's newState
        copy universe's lineCharacterTemplate to end of universe's characterGrid
        set end of universe's lineList to blankLine
    end repeat
    -- Then the rows and lines representing the input itself, centring it roughly halfway across the grid.
    set textInset to (w - seedWidth) div 2
    set stateInset to textInset + borderThickness
    repeat with thisLine in seedLines
        copy universe's rowTemplate to universe's currentRow
        copy universe's lineCharacterTemplate to universe's currentLineCharacters
        repeat with c from 1 to (count thisLine)
            set thisCharacter to character c of thisLine
            set item (textInset + c) of universe's currentLineCharacters to thisCharacter
            set item (stateInset + c) of universe's currentRow to (thisCharacter is live) as integer
        end repeat
        set end of universe's newState to universe's currentRow
        set end of universe's characterGrid to universe's currentLineCharacters
        set end of universe's lineList to universe's currentLineCharacters as text
    end repeat
    set AppleScript's text item delimiters to astid
    -- Then the rows and lines beneath and the bottom border.
    repeat (h - (headroom + lineCount)) times
        copy universe's rowTemplate to end of universe's newState
        copy universe's lineCharacterTemplate to end of universe's characterGrid
        set end of universe's lineList to blankLine
    end repeat
    repeat borderThickness times
        copy universe's rowTemplate to end of universe's newState
    end repeat
    -- Add a generation counter display line to the end of the line list.
    set end of universe's lineList to "Generation 0"
    -- Lose the no-longer-needed template lists.
    set universe's rowTemplate to missing value
    set universe's lineCharacterTemplate to universe's rowTemplate

    return universe
end newUniverse
