on task()
    -- Since the task specifically involves unixdict.txt, this code's written in
    -- the knowlege that the words are on individual lines and in dictionary order.
    set dictPath to (path to desktop as text) & "unixdict.txt"
    script o
        property wordList : paragraphs of (read file dictPath as «class utf8»)
        property matches : {}
    end script
    -- Zap words with fewer than 9 characters and work with what's left.
    repeat with i from 1 to (count o's wordList)
        if ((count item i of o's wordList) < 9) then set item i of o's wordList to missing value
    end repeat
    set o's wordList to o's wordList's every text
    set wordListCount to (count o's wordList)
    set previousNewWord to missing value
    repeat with i from 1 to (wordListCount - 8)
        set newWord to character 1 of item i of o's wordList
        set j to (i - 1)
        repeat with k from 2 to 9
            set newWord to newWord & character k of item (j + k) of o's wordList
        end repeat
        -- Since wordList's known to be in dictionary order, a lot of time can be saved
        -- by only checking the necessary few words ahead for a match instead of
        -- using AppleScript's 'is in' or 'contains' commands, which check the entire list.
        if (newWord is not previousNewWord) then
            repeat with j from i to wordListCount
                set thisWord to item j of o's wordList
                if (newWord comes after thisWord) then
                else
                    if (newWord is thisWord) then set end of o's matches to newWord
                    exit repeat
                end if
            end repeat
            set previousNewWord to newWord
        end if
    end repeat

    return o's matches
end task

task()
