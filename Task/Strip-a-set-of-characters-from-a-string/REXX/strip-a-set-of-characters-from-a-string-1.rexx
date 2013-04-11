/* Rexx */

Do
  Say stripchars("She was a soul stripper. She took my heart!", "aei")

  Return
End
Exit

stripchars:
  Procedure
Do
  Parse arg haystack, chs

  Do c_ = 1 to length(chs)
    needle = substr(chs, c_, 1)
    haystack = changestr(needle, haystack, '')
    End c_

  Return haystack
End
Exit
