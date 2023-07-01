:- object(foo).

	:- public(try/0).
	try :-
		catch(bar::message, Error, handler(Error)).

	handler(error(existence_error(predicate_declaration,message/0),_)) :-
		% handle the unknown message
		...

:- end_object.
