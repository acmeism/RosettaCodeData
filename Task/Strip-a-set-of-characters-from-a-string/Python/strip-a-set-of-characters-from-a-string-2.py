>>> import string
>>> def stripchars(s, chars):
...     return s.translate(string.maketrans("", ""), chars)
...
>>> stripchars("She was a soul stripper. She took my heart!", "aei")
'Sh ws  soul strppr. Sh took my hrt!'
