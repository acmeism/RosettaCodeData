test :- augment('test.csv', 'test.out.csv').

% augment( +InFileName, +OutFileName)
augment(InFile, OutFile)  :-
	open(OutFile, write, OutStream),
	( ( csv_read_file_row(InFile, Row, [line(Line)]),
	    % Row is of the form row( Item1, Item2, ....).
	    addrow(Row, Out),
	    csv_write_stream(OutStream, [Out], []),
	    fail
	  )
	; close(OutStream)
	).

% If the first item in a row is an integer, then append the sum;
% otherwise append 'SUM':
addrow( Term, NewTerm ) :-
	Term =.. [F | List],
	List = [X|_],
	(integer(X) -> sum_list(List, Sum) ; Sum = 'SUM'),
	append(List, [Sum], NewList),
	NewTerm =.. [F | NewList].
