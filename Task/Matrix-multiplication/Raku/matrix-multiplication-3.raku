multi infix:<×> (@A, @B) {
	@A.map: -> @a { do [+] @a Z× @B[*;$_] for ^@B[0] }
}
