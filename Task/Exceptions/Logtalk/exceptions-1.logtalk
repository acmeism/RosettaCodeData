:- object(exceptions).

    :- public(double/2).
    double(X, Y) :-
        catch(double_it(X,Y), Error, handler(Error, Y)).

    handler(error(not_a_number(X), logtalk(This::double(X,Y), Sender)), Y) :-
        % try to fix the error and resume computation;
        % if not possible, rethrow the exception
        (   catch(number_codes(Nx, X), _, fail) ->
            double_it(Nx, Y)
        ;   throw(error(not_a_number(X), logtalk(This::double(X,Y), Sender)))
        ).

    double_it(X, Y) :-
        (   number(X) ->
            Y is 2*X
        ;   this(This),
            sender(Sender),
            throw(error(not_a_number(X), logtalk(This::double(X,Y), Sender)))
        ).

:- end_object.
