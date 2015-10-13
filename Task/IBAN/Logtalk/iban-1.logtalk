:- object(iban).

	:- info([
		version is 0.1,
		author is 'Paulo Moura',
		date is 2015/10/11,
		comment is 'IBAN validation example using DCG rules.'
	]).

	:- public(valid/1).

	valid(IBAN) :-
		phrase(iban, IBAN), !.

	iban -->
		country_code(Code), check_digits(Check), bban(BBAN),
		{(BBAN*1000000 + Code*100 + Check) mod 97 =:= 1}.

	country_code(Code) -->
		letter_digits(L1, D3, D2), letter_digits(L0, D1, D0),
		{country_code([L1, L0]), Code is D3*1000 + D2*100 + D1*10 + D0}.

	check_digits(Check) -->
		digit(D1), digit(D0),
		{Check is D1*10 + D0}.

	bban(BBAN) -->
		bban_codes(Digits),
		{digits_to_integer(Digits, BBAN, Count), Count =< 30}.

	bban_codes(Ds) -->
		" ", bban_codes(Ds).
	bban_codes([D| Ds]) -->
		digit(D), bban_codes(Ds).
	bban_codes([D1, D0| Ds]) -->
		letter_digits(_, D1, D0), bban_codes(Ds).
	bban_codes([]) -->
		[].

	digit(D) -->
		[C],
		{0'0 =< C, C =< 0'9, D is C - 0'0}.

	letter_digits(C, D1, D0) -->
		[C],
		{	(	0'A =< C, C =< 0'Z ->
				D is C - 0'A + 10
			;	0'a =< C, C =< 0'z,
				D is C - 0'a + 10
			),
			D1 is D div 10,
			D0 is D mod 10
		}.

	digits_to_integer(Digits, BBAN, Count) :-
		digits_to_integer(Digits, 0, BBAN, 0, Count).

	digits_to_integer([], BBAN, BBAN, Count, Count).
	digits_to_integer([Digit| Digits], BBAN0, BBAN, Count0, Count) :-
		BBAN1 is BBAN0 * 10 + Digit,
		Count1 is Count0 + 1,
		digits_to_integer(Digits, BBAN1, BBAN, Count1, Count).

	country_code("AL").
	country_code("AD").
	country_code("AT").
	country_code("AZ").
	country_code("BE").
	country_code("BH").
	country_code("BA").
	country_code("BR").
	country_code("BG").
	country_code("CR").
	country_code("HR").
	country_code("CY").
	country_code("CZ").
	country_code("DK").
	country_code("DO").
	country_code("EE").
	country_code("FO").
	country_code("FI").
	country_code("FR").
	country_code("GE").
	country_code("DE").
	country_code("GI").
	country_code("GR").
	country_code("GL").
	country_code("GT").
	country_code("HU").
	country_code("IS").
	country_code("IE").
	country_code("IL").
	country_code("IT").
	country_code("KZ").
	country_code("KW").
	country_code("LV").
	country_code("LB").
	country_code("LI").
	country_code("LT").
	country_code("LU").
	country_code("MK").
	country_code("MT").
	country_code("MR").
	country_code("MU").
	country_code("MC").
	country_code("MD").
	country_code("ME").
	country_code("NL").
	country_code("NO").
	country_code("PK").
	country_code("PS").
	country_code("PL").
	country_code("PT").
	country_code("RO").
	country_code("SM").
	country_code("SA").
	country_code("RS").
	country_code("SK").
	country_code("SI").
	country_code("ES").
	country_code("SE").
	country_code("CH").
	country_code("TN").
	country_code("TR").
	country_code("AE").
	country_code("GB").
	country_code("VG").

:- end_object.
