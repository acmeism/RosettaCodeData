:- object(foo,
	implements(forwarding)).

	forward(Message) :-
		% handle the unknown message
		...

:- end_object.
