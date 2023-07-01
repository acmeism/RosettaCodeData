:- object(minheap,
	extends(heap(<))).

	:- info([
		version is 1:0:0,
		author is 'Paulo Moura.',
		date is 2010-02-19,
		comment is 'Min-heap implementation. Uses standard order to compare keys.'
	]).

:- end_object.


:- object(maxheap,
	extends(heap(>))).

	:- info([
		version is 1:0:0,
		author is 'Paulo Moura.',
		date is 2010-02-19,
		comment is 'Max-heap implementation. Uses standard order to compare keys.'
	]).

:- end_object.
