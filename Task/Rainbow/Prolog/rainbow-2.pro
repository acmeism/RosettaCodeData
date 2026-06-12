:- use_module(library(ansi_term)).

:-  ansi_format([fg(255,  10,  10)], 'R',   []),
    ansi_format([fg(240, 120,   0)], 'A',   []),
    ansi_format([fg(200, 220,   0)], 'I',   []),
    ansi_format([fg(  0, 225,  40)], 'N',   []),
    ansi_format([fg(  0, 200, 240)], 'B',   []),
    ansi_format([fg(  0,   0, 255)], 'O',   []),
    ansi_format([fg(240,   0, 240)], 'W~n', []).
