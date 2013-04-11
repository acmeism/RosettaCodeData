:- object(hello_world).

    % the initialization/1 directive argument is automatically executed
    % when the object is loaded into memory:
    :- initialization((nl, write('Goodbye, World!'), nl)).

:- end_object.
