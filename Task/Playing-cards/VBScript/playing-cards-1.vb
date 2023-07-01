class playingcard
	dim suit
	dim pips
end class

class carddeck
	private suitnames
	private pipnames
	private cardno
	private deck(52)
	private nTop
	
	sub class_initialize
		dim suit
		dim pips
		suitnames = split("H,D,C,S",",")
		pipnames = split("A,2,3,4,5,6,7,8,9,10,J,Q,K",",")
		cardno = 0

		for suit = 1 to 4
			for pips = 1 to 13
				set deck(cardno) = new playingcard
				deck(cardno).suit = suitnames(suit-1)
				deck(cardno).pips = pipnames(pips-1)
				cardno = cardno + 1
			next
		next
		nTop = 0
	end sub
	
	public sub showdeck
		dim a
		redim a(51-nTop)
		for i = nTop to 51
			a(i) = deck(i).pips & deck(i).suit
		next
		wscript.echo join( a, ", ")
	end sub
	
	public sub shuffle
		dim r
		randomize timer
		for i = nTop to 51
			r = int( rnd * ( 52 - nTop ) )
			if r <> i then
				objswap deck(i),deck(r)
			end if
		next
	end sub

	public function deal()
		set deal = deck( nTop )
		nTop = nTop + 1
	end function

	public property get cardsRemaining
		cardsRemaining = 52 - nTop
	end property
	
	private sub objswap(   a,   b )
		dim tmp
		set tmp = a
		set a = b
		set b = tmp
	end sub
end class
