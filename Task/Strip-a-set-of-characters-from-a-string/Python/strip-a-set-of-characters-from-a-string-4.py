>>> import re
>>> def stripchars(s, chars):
	return re.sub('[%s]+' % re.escape(chars), '', s)

>>> stripchars("She was a soul stripper. She took my heart!", "aei")
'Sh ws  soul strppr. Sh took my hrt!'
>>>
