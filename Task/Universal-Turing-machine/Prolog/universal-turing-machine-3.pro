busy_beaver_config(IS, FS, RS, B, S) :-
    IS = 'A',               % initial state
    FS = ['HALT'],          % halting states
    RS = [IS, 'B', 'C'],    % running states
    B  = 0,                 % blank symbol
    S  = [B, 1].            % valid symbols
busy_beaver('A', 0, 1, right, 'B').
busy_beaver('A', 1, 1, left,  'C').
busy_beaver('B', 0, 1, left,  'A').
busy_beaver('B', 1, 1, right, 'B').
busy_beaver('C', 0, 1, left,  'B').
busy_beaver('C', 1, 1, stay,  'HALT').

turing(busy_beaver_config, busy_beaver, [], TapeOut).
