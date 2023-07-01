:- protocol(seqp).

    :- public(init/0).    % reset to a beginning state if meaningful

    :- public(nth/2).     % get the nth value of the sequence

    :- public(to_nth/2).  % get from the start to the nth value of the sequence as a list

:- end_protocol.
