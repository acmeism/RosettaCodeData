' ============================================
' https://rosettacode.org/wiki/URL_decoding
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================

' Convert two-char hex string to decimal value
DEF FN HexVal$(h$)
	LET digits$ = "0123456789ABCDEF"
	LET hi$ = INSTR(digits$, UCASE(LEFT(h$, 1))) - 1
	LET lo$ = INSTR(digits$, UCASE(RIGHT(h$, 1))) - 1
	RETURN hi$ * 16 + lo$
END DEF

' Decode a percent-encoded URL string
DEF FN UrlDecode$(s$)
	LET result$ = ""
	LET i$ = 1
	WHILE i$ <= LEN(s$)
		IF MID(s$, i$, 1) = "%" THEN
			result$ = result$ + CHR(FN HexVal$(MID(s$, i$ + 1, 2)))
			i$+= 3
		ELSE
			result$ = result$ + MID(s$, i$, 1)
			i$+= 1
		END IF
	WEND
	RETURN result$
END DEF

[inits]
	LET decoded$

[main]
	decoded$ = FN UrlDecode$("http%3A%2F%2Ffoo%20bar%2F")
	PRINT decoded$

	decoded$ = FN UrlDecode$("google.com/search?q=%60Abdu%27l-Bah%C3%A1")
	PRINT decoded$
END

' Output:
' http://foo bar/
' google.com/search?q=`Abdu'l-BahÃ¡
' Note: %C3%A1 encodes á as a UTF-8 two-byte sequence.
' CHR() is single-byte, so multi-byte UTF-8 chars render as two raw bytes.
