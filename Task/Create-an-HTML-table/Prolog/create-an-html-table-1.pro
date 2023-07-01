:- use_module(library(http/html_write)).

theader([]) --> []. theader([H|T])  --> html(th(H)), theader(T).
trows([],_) --> []. trows([R|T], N) --> html(tr([td(N),\trow(R)])), { N1 is N + 1 }, trows(T, N1).
trow([])    --> []. trow([E|T])     --> html(td(E)), trow(T).

table :-
	Header = ['X','Y','Z'],
	Rows = [
		[7055,5334,5795],
		[2895,3019,7747],
		[140,7607,8144],
		[7090,475,4140]
	],
	phrase(html(table([tr(\theader(Header)), \trows(Rows,1)])),  Out, []),
	print_html(Out).
