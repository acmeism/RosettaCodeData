incrementer_config(IS, FS, RS, B, S) :-
    IS = q0,      % initial state
    FS = [qf],    % halting states
    RS = [IS],    % running states
    B  = 0,       % blank symbol
    S  = [B, 1].  % valid symbols
incrementer(q0, 1, 1, right, q0).
incrementer(q0, b, 1, stay,  qf).

turing(incrementer_config, incrementer, [1, 1, 1], TapeOut).
