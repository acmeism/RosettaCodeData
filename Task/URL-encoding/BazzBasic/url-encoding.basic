' ============================================
' https://rosettacode.org/wiki/URL_encoding
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================

' Convert decimal value to two-char uppercase hex string
DEF FN ToHex$(n$)
	LET digits$ = "0123456789ABCDEF"
	RETURN MID(digits$, INT(n$ / 16) + 1, 1) + MID(digits$, MOD(n$, 16) + 1, 1)
END DEF

' Percent-encode all characters except 0-9, A-Z, a-z
DEF FN UrlEncode$(s$)
	LET result$ = ""
	LET i$ = 1
	LET c$ = ""
	LET code$ = 0
	WHILE i$ <= LEN(s$)
		c$ = MID(s$, i$, 1)
		code$ = ASC(c$)
		IF (code$ >= 48 AND code$ <= 57) OR (code$ >= 65 AND code$ <= 90) OR (code$ >= 97 AND code$ <= 122) THEN
			result$+= c$
		ELSE
			result$ = result$ + "%" + FN ToHex$(code$)
		END IF
		i$ = i$ + 1
	WEND
	RETURN result$
END DEF

[inits]
	LET encoded$

[main]
	encoded$ = FN UrlEncode$("http://foo bar/")
	PRINT encoded$
END

' Output:
' http%3A%2F%2Ffoo%20bar%2F
