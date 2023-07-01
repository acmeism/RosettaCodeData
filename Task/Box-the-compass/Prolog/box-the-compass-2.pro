printTableRow(Angle) :- compassangle(Index, Name, _, Angle),
                        write(Index), write('    '),
                        write(Name), write('   '),
                        write(Angle).

printTable([X|Xs]) :- printTableRow(X), nl, printTable(Xs),!.
printTable([]).
