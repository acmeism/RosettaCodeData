% convert text to morse
% query text2morse(Text, Morse)
% where
% Text is string to convert
% Morse is Morse representation
% There is a space between chars and double space between words
%
text2morse(Text, Morse) :-
	string_lower(Text, TextLower),			% rules are in lower case
	string_chars(TextLower, Chars),			% convert string into list of chars
	chars2morse(Chars, MorseChars),			% convert each char into morse
	string_chars(MorsePlusSpace, MorseChars),	% append returned string list into single string
	string_concat(Morse, ' ', MorsePlusSpace).	% Remove trailing space

chars2morse([], "").
chars2morse([H|CharTail], Morse) :-
	morse(H, M),
	chars2morse(CharTail, MorseTail),
	string_concat(M,' ', MorseSpace),
	string_concat(MorseSpace, MorseTail, Morse).

% space
morse(' ', " ").
% letters
morse('a', ".-").
morse('b', "-...").
morse('c', "-.-.").
morse('d', "-..").
morse('e', ".").
morse('f', "..-.").
morse('g', "--.").
morse('h', "....").
morse('i', "..").
morse('j', ".---").
morse('k', "-.-").
morse('l', ".-..").
morse('m', "--").
morse('n', "-.").
morse('o', "---").
morse('p', ".--.").
morse('q', "--.-").
morse('r', ".-.").
morse('s', "...").
morse('t', "-").
morse('u', "..-").
morse('v', "...-").
morse('w', ".--").
morse('x', "-..-").
morse('y', "-.--").
morse('z', "--..").
% numbers
morse('1', ".----").
morse('2', "..---").
morse('3', "...--").
morse('4', "....-").
morse('5', ".....").
morse('6', "-....").
morse('7', "--...").
morse('8', "---..").
morse('9', "----.").
morse('0', "-----").
% common punctuation
morse('.', ".-.-.-").
morse(',', "--..--").
morse('/', "-..-.").
morse('?', "..--..").
morse('=', "-...-").
morse('+', ".-.-.").
morse('-', "-....-").
morse('@', ".--.-.").
