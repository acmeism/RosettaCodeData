:- object(query_foo).

	:- public(query/0).
	query :-
		write('Message: '),
		read(Message),
		foo::Message.
		write('Reply: '),
		write(Message), nl.

:- end_object.
