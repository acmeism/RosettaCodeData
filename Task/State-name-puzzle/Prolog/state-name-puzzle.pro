state_name_puzzle :-
	L = ["Alabama", "Alaska", "Arizona", "Arkansas",
	     "California", "Colorado", "Connecticut",
	     "Delaware",
	     "Florida", "Georgia", "Hawaii",
	     "Idaho", "Illinois", "Indiana", "Iowa",
	     "Kansas", "Kentucky", "Louisiana",
	     "Maine", "Maryland", "Massachusetts", "Michigan",
	     "Minnesota", "Mississippi", "Missouri", "Montana",
	     "Nebraska", "Nevada", "New Hampshire", "New Jersey",
	     "New Mexico", "New York", "North Carolina", "North Dakota",
	     "Ohio", "Oklahoma", "Oregon",
	     "Pennsylvania", "Rhode Island",
	     "South Carolina", "South Dakota", "Tennessee", "Texas",
	     "Utah", "Vermont", "Virginia",
	     "Washington", "West Virginia", "Wisconsin", "Wyoming",
	     "New Kory", "Wen Kory", "York New", "Kory New", "New Kory"],

	maplist(goedel, L, R),

	% sort remove duplicates
	sort(R, RS),

	study(RS).

study([]).

study([V-Word|T]) :-
	study_1_Word(V-Word, T, T),
	study(T).


study_1_Word(_, [], _).
study_1_Word(V1-W1, [V2-W2 | T1], T) :-
	TT is V1+V2,
	study_2_Word(W1, W2, TT, T),
	study_1_Word(V1-W1, T1, T).

study_2_Word(_W1, _W2, _TT, []).

study_2_Word(W1, W2, TT, [V3-W3 | T]) :-
	(   W2 \= W3 -> study_3_Word(W1, W2, TT, V3-W3, T); true),
	study_2_Word(W1, W2, TT, T).

study_3_Word(_W1, _W2, _TT, _V3-_W3, []).

study_3_Word(W1, W2, TT, V3-W3, [V4-W4|T]) :-
	TT1 is V3 + V4,
	(   TT1 < TT -> study_3_Word(W1, W2, TT, V3-W3, T)
	;   (TT1 = TT -> ( W4 \= W2 -> format('~w & ~w  with ~w & ~w~n', [W1, W2, W3, W4])
	                               ; true),
           	         study_3_Word(W1, W2, TT, V3-W3, T))
	;   true).

% Compute a Goedel number for the word
goedel(Word, Goedel-A) :-
	name(A, Word),
	downcase_atom(A, Amin),
	atom_codes(Amin, LA),
	compute_Goedel(LA, 0, Goedel).

compute_Goedel([], G, G).

compute_Goedel([32|T], GC, GF) :-
	compute_Goedel(T, GC, GF).

compute_Goedel([H|T], GC, GF) :-
	Ind is H - 97,
	GC1 is GC + 26 ** Ind,
	compute_Goedel(T, GC1, GF).
