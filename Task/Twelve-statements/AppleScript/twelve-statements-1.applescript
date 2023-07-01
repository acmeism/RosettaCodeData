on twelveStatements()
    set statements to " 1.  This is a numbered list of twelve statements.
 2.  Exactly 3 of the last 6 statements are true.
 3.  Exactly 2 of the even-numbered statements are true.
 4.  If statement 5 is true, then statements 6 and 7 are both true.
 5.  The 3 preceding statements are all false.
 6.  Exactly 4 of the odd-numbered statements are true.
 7.  Either statement 2 or 3 is true, but not both.
 8.  If statement 7 is true, then 5 and 6 are both true.
 9.  Exactly 3 of the first 6 statements are true.
10.  The next two statements are both true.
11.  Exactly 1 of statements 7, 8 and 9 are true.
12.  Exactly 4 of the preceding statements are true."

    script o
        property posits : {}
        property upshots : missing value

        on countTrues(indexList)
            set sum to 0
            repeat with i in indexList
                if (my posits's item i) then set sum to sum + 1
            end repeat
            return sum
        end countTrues
    end script
    -- While setting up, test statement 1, whose truth isn't about the others' truths.
    set statements to statements's paragraphs
    set nStatements to (count statements)
    set statement1Truth to (nStatements = 12)
    repeat with stmt from 1 to nStatements
        set end of o's o's posits to false
        tell (statements's item stmt's words) to set statement1Truth to ¬
            ((statement1Truth) and ((count) > 1) and (beginning = stmt as text))
    end repeat

    set output to {}
    set firstIteration to true
    repeat (2 ^ nStatements) times
        -- Postulate answer:
        if (firstIteration) then
            set firstIteration to false
        else -- "Increment" the 'posits' boolean array binarily.
            repeat with stmt from 1 to nStatements
                set o's posits's item stmt to (not (o's posits's item stmt))
                if (result) then exit repeat -- No carry.
            end repeat
        end if

        -- Test consistency:
        tell o's posits to set o's upshots to {statement1Truth, ¬
            (o's countTrues({7, 8, 9, 10, 11, 12}) = 3), ¬
            (o's countTrues({2, 4, 6, 8, 10, 12}) = 2), ¬
            ((not (item 5)) or ((item 6) and (item 7))), ¬
            (not ((item 2) or (item 3) or (item 4))), ¬
            (o's countTrues({1, 3, 5, 7, 9, 11}) = 4), ¬
            ((item 2) ≠ (item 3)), ¬
            ((not (item 7)) or ((item 5) and (item 6))), ¬
            (o's countTrues({1, 2, 3, 4, 5, 6}) = 3), ¬
            ((item 11) and (item 12)), ¬
            (o's countTrues({7, 8, 9}) = 1), ¬
            (o's countTrues({1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}) = 4)}

        set nMatches to 0
        repeat with stmt from 1 to nStatements
            if ((o's posits's item stmt) = (o's upshots's item stmt)) then set nMatches to nMatches + 1
        end repeat
        if (nMatches > nStatements - 2) then
            set statementsPositedTrue to {}
            repeat with stmt from 1 to nStatements
                set thisPosit to o's posits's item stmt
                if (thisPosit) then set end of statementsPositedTrue to stmt
                if ((thisPosit) ≠ (o's upshots's item stmt)) then set failure to stmt
            end repeat
            set statementsPositedTrue's last item to "and " & statementsPositedTrue's end
            if ((count statementsPositedTrue) > 2) then
                set statementsPositedTrue to join(statementsPositedTrue, ", ")
            else
                set statementsPositedTrue to join(statementsPositedTrue, space)
            end if
            if (nMatches = nStatements) then
                set output's end to "SOLUTION: statements " & statementsPositedTrue & " are true."
            else
                set output's end to "Near miss when statements " & statementsPositedTrue & ¬
                    " are posited true: posit for statement " & failure & " fails."
            end if
        end if
    end repeat

    return join(output, linefeed)
end twelveStatements

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

twelveStatements()
