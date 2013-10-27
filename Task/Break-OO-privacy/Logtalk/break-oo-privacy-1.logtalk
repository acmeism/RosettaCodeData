:- object(foo).

    % be sure that context switching calls are allowed
    :- set_logtalk_flag(context_switching_calls, allow).

    % declare and define a private method
    :- private(bar/1).
    bar(1).
    bar(2).
    bar(3).

:- end_object.
