isWordChar = (c) -> /^\w/.test c
isLastChar = (c) -> c is '.'

oddWord = (get, put) ->
	forwardWord = ->
		loop
			c = get()
			put(c)
			unless isWordChar(c)
				return not isLastChar(c)
	
	reverseWord = (outputPending = (->)) ->
		c = get()
		if isWordChar(c)
			reverseWord ->
				put(c)
				outputPending()
		else
			outputPending()
			put(c)
			return not isLastChar(c)
	
	continue while forwardWord() and reverseWord()
