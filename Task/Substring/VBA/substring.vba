Public Sub substring()
'(1) starting from n characters in and of m length;
'(2) starting from n characters in, up to the end of the string;
'(3) whole string minus last character;
'(4) starting from a known character within the string and of m length;
'(5) starting from a known substring within the string and of m length.

    sentence = "the last thing the man said was the"
    n = 10: m = 5

    '(1)
    Debug.Print Mid(sentence, n, 5)
    '(2)
    Debug.Print Right(sentence, Len(sentence) - n + 1)
    '(3)
    Debug.Print Left(sentence, Len(sentence) - 1)
    '(4)
    k = InStr(1, sentence, "m")
    Debug.Print Mid(sentence, k, 5)
    '(5)
    k = InStr(1, sentence, "aid")
    Debug.Print Mid(sentence, k, 5)
End Sub
