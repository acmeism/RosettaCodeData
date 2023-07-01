common_sublist(A, B, M) :-
	append(_, Ma, A),
	append(M, _, Ma),
	append(_, Mb, B),
	append(M, _, Mb).	

longest_list([], L, _, L).
longest_list([L|Ls], LongestList, LongestLength, Result) :-	
	length(L, Len),
	Len >= LongestLength -> longest_list(Ls, L, Len, Result)
	; longest_list(Ls, LongestList, LongestLength, Result).
	
longest_substring(A, B, Result) :-
	string_chars(A, AChars),
	string_chars(B, BChars),
	findall(SubString, (
		dif(SubString, []), common_sublist(AChars, BChars, SubString)
	), AllSubstrings),
	longest_list(AllSubstrings, [], 0, LongestSubString),
	string_chars(Result, LongestSubString).
