on redact(theText, redactionTargets, options)
    (* Script object containing the basic process. *)
    script default
        property textItems : missing value
        property outputText : theText

        -- Replace every instance of each of the passed redaction targets with an "X" sequence of the same length.
        on redact()
            set astid to AppleScript's text item delimiters
            repeat with thisTarget in (redactionTargets as list)
                set AppleScript's text item delimiters to thisTarget's contents
                set my textItems to my outputText's text items
                applyOption()
                set AppleScript's text item delimiters to getXs(count thisTarget)
                set my outputText to my textItems as text
            end repeat
            set astid to AppleScript's text item delimiters
        end redact

        on applyOption()
        end applyOption

        on getXs(targetLength)
            set Xs to ""
            repeat targetLength times
                set Xs to Xs & "X"
            end repeat

            return Xs
        end getXs
    end script

    (* Child script objects with their own applyOption() handlers for word-match and overkill. *)
    script wordMatch
        property parent : default
        property newTextItems : missing value

        -- Derive new text items from those just extracted with the current delimiter, losing any delimitation within words.
        on applyOption()
            set my newTextItems to {}
            set i to 1
            repeat with j from 2 to (count my textItems)
                set precedingExtract to text from text item i to text item (j - 1) of my outputText -- Substring from the text.
                set thisTextItem to item j of my textItems -- Text item from the list.
                if not ¬
                    ((precedingExtract ends with "-") or ¬
                        (((count precedingExtract's words) > 0) and (precedingExtract ends with precedingExtract's last word)) or ¬
                        (thisTextItem begins with "-") or ¬
                        (((count thisTextItem's words) > 0) and (thisTextItem begins with thisTextItem's first word))) then
                    set end of my newTextItems to precedingExtract
                    set i to j
                end if
            end repeat
            set end of my newTextItems to text from text item i to text item j of my outputText

            set my textItems to my newTextItems
        end applyOption
    end script

    script overkill
        property parent : default

        -- Where the extracted text items are delimited within words, replace the word stumps' characters with "X"s.
        on applyOption()
            repeat with i from 2 to (count my textItems)
                set precedingTextItem to item (i - 1) of my textItems
                if ((count precedingTextItem's words) > 0) then
                    set lastword to precedingTextItem's last word
                    if ((precedingTextItem ends with lastword) or (precedingTextItem ends with (lastword & "-"))) then
                        set editLength to (count text from last word to end of precedingTextItem)
                        set Xs to getXs(editLength)
                        if ((count precedingTextItem) > editLength) then ¬
                            set Xs to text 1 thru -(editLength + 1) of precedingTextItem & Xs
                        set item (i - 1) of my textItems to Xs
                    end if
                else if ((precedingTextItem is "-") and (i > 2)) then -- Hyphen between two target instances.
                    set item (i - 1) of my textItems to "X"
                end if
                set thisTextItem to item i of my textItems
                if ((count thisTextItem's words) > 0) then
                    set firstWord to thisTextItem's first word
                    if ((thisTextItem begins with firstWord) or (thisTextItem begins with ("-" & firstWord))) then
                        set editLength to (count text 1 thru first word of thisTextItem)
                        set Xs to getXs(editLength)
                        if ((count thisTextItem) > editLength) then set Xs to Xs & text (editLength + 1) thru end of thisTextItem
                        set item i of my textItems to Xs
                    end if
                end if
            end repeat
        end applyOption
    end script

    (* Outer handler code. *)
    -- Select the script object to use as the redactor.
    if (options contains "w") then
        set redactor to wordMatch
    else if (options contains "o") then
        set redactor to overkill
    else
        set redactor to default
    end if
    -- Invoke it with the necessary text comparison attributes imposed.
    if ((options contains "i") or ((options does not contain "s") and ("i" = "I"))) then
        considering white space and punctuation but ignoring case
            tell redactor to redact()
        end considering
    else
        considering white space, punctuation and case
            tell redactor to redact()
        end considering
    end if

    return redactor's outputText
end redact
