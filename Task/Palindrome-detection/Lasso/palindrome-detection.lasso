define ispalindrome(text::string) => {

	local(_text = string(#text)) // need to make copy to get rid of reference issues

	#_text -> replace(regexp(`(?:$|\W)+`), -ignorecase)

	local(reversed = string(#_text))
	#reversed -> reverse

	return #_text == #reversed
}

ispalindrome('Tätatät') // works with high ascii
ispalindrome('Hello World')

ispalindrome('A man, a plan, a canoe, pasta, heros, rajahs, a coloratura, maps, snipe, percale, macaroni, a gag, a banana bag, a tan, a tag, a banana bag again (or a camel), a crepe, pins, Spam, a rut, a Rolo, cash, a jar, sore hats, a peon, a canal – Panama!')
