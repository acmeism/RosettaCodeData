:- object(point(_X_, _Y_)).

    :- public([x/1, y/1, print/0]).
    x(_X_).
    y(_Y_).

    print :- logtalk::print_message(information, shapes, @point(_X_,_Y_)).

:- end_object.

:- object(circle(_X_, _Y_, _R_),
    extends(point(_X_, _Y_))).

    :- public([r/1]).
    r(_R_).

    print :- logtalk::print_message(information, shapes, @circle(_X_,_Y_,_R_)).

:- end_object.
