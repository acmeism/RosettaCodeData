>>> marker, line = '#', 'apples, pears # and bananas'
>>> line[:line.index(marker)].strip()
'apples, pears'
>>>
>>> marker, line = ';', '  apples, pears ; and bananas'
>>> line[:line.index(marker)].strip()
'apples, pears'
