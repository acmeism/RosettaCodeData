:-module(shannon_entropy, [shannon_entropy/2]).

%!	shannon_entropy(+String, -Entropy) is det.
%
%	Calculate the Shannon Entropy of String.
%
%	Example query:
%	==
%	?- shannon_entropy(1223334444, H).
%	H = 1.8464393446710154.
%	==
%
shannon_entropy(String, Entropy):-
	atom_chars(String, Cs)
	,relative_frequencies(Cs, Frequencies)
	,findall(CI
		,(member(_C-F, Frequencies)
		 ,log2(F, L)
		 ,CI is F * L
		 )
		,CIs)
	,foldl(sum, CIs, 0, E)
	,Entropy is -E.

%!	frequencies(+Characters,-Frequencies) is det.
%
%	Calculates the relative frequencies of elements in the list of
%	Characters.
%
%	Frequencies is a key-value list with elements of the form:
%	C-F, where C a character in the list and F its relative
%	frequency in the list.
%
%	Example query:
%	==
%	?- relative_frequencies([a,a,a,b,b,b,b,b,b,c,c,c,a,a,f], Fs).
%	Fs = [a-0.3333333333333333, b-0.4, c-0.2,f-0.06666666666666667].
%	==
%
relative_frequencies(List, Frequencies):-
	run_length_encoding(List, Rle)
        % Sort Run-length encoded list and aggregate lengths by element
	,keysort(Rle, Sorted_Rle)
	,group_pairs_by_key(Sorted_Rle, Elements_Run_lengths)
	,length(List, Elements_in_list)
	,findall(E-Frequency_of_E
		,(member(E-RLs, Elements_Run_lengths)
                 % Sum the list of lengths of runs of E
		 ,foldl(plus, RLs, 0, Occurences_of_E)
		 ,Frequency_of_E is Occurences_of_E / Elements_in_list
		 )
		,Frequencies).


%!	run_length_encoding(+List, -Run_length_encoding) is det.
%
%	Converts a list to its run-length encoded form where each "run"
%	of contiguous repeats of the same element is replaced by that
%	element and the length of the run.
%
%	Run_length_encoding is a key-value list, where each element is a
%	term:
%
%	Element:term-Repetitions:number.
%
%	Example query:
%	==
%       ?- run_length_encoding([a,a,a,b,b,b,b,b,b,c,c,c,a,a,f], RLE).
%	RLE = [a-3, b-6, c-3, a-2, f-1].
%	==
%
run_length_encoding([], []-0):-
	!. % No more results needed.

run_length_encoding([Head|List], Run_length_encoded_list):-
	run_length_encoding(List, [Head-1], Reversed_list)
	% The resulting list is in reverse order due to the head-to-tail processing
	,reverse(Reversed_list, Run_length_encoded_list).

%!	run_length_encoding(+List,+Initialiser,-Accumulator) is det.
%
%	Business end of run_length_encoding/3. Calculates the run-length
%	encoded form of a list and binds the result to the Accumulator.
%	Initialiser is a list [H-1] where H is the first element of the
%	input list.
%
run_length_encoding([], Fs, Fs).

% Run of F consecutive occurrences of C
run_length_encoding([C|Cs],[C-F|Fs], Acc):-
        % Backtracking would produce successive counts
	% of runs of C at different indices in the list.
	!
	,F_ is F + 1
	,run_length_encoding(Cs, [C-F_| Fs], Acc).

% End of a run of consecutive identical elements.
run_length_encoding([C|Cs], Fs, Acc):-
	run_length_encoding(Cs,[C-1|Fs], Acc).


/* Arithmetic helper predicates */

%!	log2(N, L2_N) is det.
%
%	L2_N is the logarithm with base 2 of N.
%
log2(N, L2_N):-
	L_10 is log10(N)
	,L_2 is log10(2)
	,L2_N is L_10 / L_2.

%!	sum(+A,+B,?Sum) is det.
%
%	True when Sum is the sum of numbers A and B.
%
%	Helper predicate to allow foldl/4 to do addition. The following
%	call will raise an error (because there is no predicate +/3):
%	==
%	foldl(+, [1,2,3], 0, Result).
%	==
%
%	This will not raise an error:
%	==
%	foldl(sum, [1,2,3], 0, Result).
%	==
%
sum(A, B, Sum):-
	must_be(number, A)
	,must_be(number, B)
	,Sum is A + B.
