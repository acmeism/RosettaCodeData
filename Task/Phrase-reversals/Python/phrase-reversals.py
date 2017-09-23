>>> phrase = "rosetta code phrase reversal"
>>> phrase[::-1]					  # Reversed.
'lasrever esarhp edoc attesor'
>>> ' '.join(word[::-1] for word in phrase.split())	  # Words reversed.
'attesor edoc esarhp lasrever'
>>> ' '.join(phrase.split()[::-1])	                  # Word order reversed.
'reversal phrase code rosetta'
>>>
