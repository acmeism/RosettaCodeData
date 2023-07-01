Public Sub string_matching()
    word = "the"                                        '-- (also try this with "th"/"he")
    sentence = "the last thing the man said was the"
    '--       sentence = "thelastthingthemansaidwasthe" '-- (practically the same results)

    '-- A common, but potentially inefficient idiom for checking for a substring at the start is:
    If InStr(1, sentence, word) = 1 Then
        Debug.Print "yes(1)"
    End If
    '-- A more efficient method is to test the appropriate slice
    If Len(sentence) >= Len(word) _
        And Mid(sentence, 1, Len(word)) = word Then
        Debug.Print "yes(2)"
    End If
    '-- Which is almost identical to checking for a word at the end
    If Len(sentence) >= Len(word) _
        And Mid(sentence, Len(sentence) - Len(word) + 1, Len(word)) = word Then
        Debug.Print "yes(3)"
    End If
    '-- Or sometimes you will see this, a tiny bit more efficient:
    If Len(sentence) >= Len(word) _
    And InStr(Len(sentence) - Len(word) + 1, sentence, word) Then
        Debug.Print "yes(4)"
    End If
    '-- Finding all occurences is a snap:
    r = InStr(1, sentence, word)
    Do While r <> 0
        Debug.Print r
        r = InStr(r + 1, sentence, word)
    Loop
End Sub
