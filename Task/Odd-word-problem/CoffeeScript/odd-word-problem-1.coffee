isWordChar = (c) -> /^\w/.test c
isLastChar = (c) -> c is '.'

# Pass a function that returns an input character and one that outputs a
# character. JS platforms' ideas of single-character I/O vary widely, but this
# abstraction is adaptable to most or all.
oddWord = (get, put) ->
	forwardWord = ->
		loop
			# No magic here; buffer then immediately output.
			c = get()
			put(c)
			unless isWordChar(c)
				return not isLastChar(c)
	
	# NB: (->) is a CoffeeScript idiom for no-op.
	reverseWord = (outputPending = (->)) ->
		c = get()
		if isWordChar(c)
			# Continue word.
			# Tell recursive call to output this character, then any previously
			# pending characters, after the next word character, if any, has
			# been output.
			reverseWord ->
				put(c)
				outputPending()
		else
			# Word is done.
			# Output previously pending characters, then this punctuation.
			outputPending()
			put(c)
			return not isLastChar(c)
	
	# Alternate between forward and reverse until one or the other reports that
	# the end-of-input mark has been reached (causing a return of false).
	continue while forwardWord() and reverseWord()
