hamming(N) :-
     % to stop cleanly
     nb_setval(go, 1),

     % display list
     (	 N = 20 -> watch_20(20, L); watch(1,N,L)),

     % go
     L=[1|L235],
     multlist(L,2,L2),
     multlist(L,3,L3),
     multlist(L,5,L5),
     merge_(L2,L3,L23),
     merge_(L5,L23,L235).


%% multlist(L,N,LN)
%% multiply each element of list L with N, resulting in list LN
%% here only do multiplication for 1st element, then use multlist recursively
multlist([X|L],N,XLN) :-
	% the trick to stop
	nb_getval(go, 1) ->

	% laziness flavor	
	when(ground(X),
	     (	 XN is X*N,
		 XLN=[XN|LN],
		 multlist(L,N,LN)));

	true.

merge_([X|In1],[Y|In2],XYOut) :-
	% the trick to stop
	nb_getval(go, 1) ->

	% laziness flavor
	(   X < Y -> XYOut = [X|Out], In11 = In1, In12 = [Y|In2]
	;   X = Y -> XYOut = [X|Out], In11 = In1, In12 = In2
	;            XYOut = [Y|Out], In11 = [X | In1], In12 = In2),
	freeze(In11,freeze(In12, merge_(In11,In12,Out)));

	true.

%% display nth element
watch(Max, Max, [X|_]) :-
	% laziness flavor
	when(ground(X),
	     (format('~w~n', [X]),

	      % the trick to stop
	      nb_linkval(go, 0))).


watch(N, Max, [_X|L]):-
	 N1 is N + 1,
	 watch(N1, Max, L).


%% display nth element
watch_20(1, [X|_]) :-
	% laziness flavor
	when(ground(X),
	     (format('~w~n', [X]),

	      % the trick to stop
	      nb_linkval(go, 0))).


watch_20(N, [X|L]):-
	% laziness flavor
	when(ground(X),
	     (format('~w ', [X]),
	      N1 is N - 1,
	      watch_20(N1, L))).
