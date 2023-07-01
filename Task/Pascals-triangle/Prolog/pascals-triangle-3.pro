%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Produce a pascal's triangle of depth N
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%  Prolog is declarative.  The predicate pascal/3 below says that to produce
%  a row of depth N, we can do so by first producing the row at depth(N-1),
%  and then adding the paired values in that row.  The triangle is produced
%  by prepending the row at N-1 to the preceding rows as recursion unwinds.
%  The triangle produced by pascal/3 is upside down and lacks the last row,
%  so pascal/2 prepends the last row to the triangle and reverses it.
%  Finally, pascal/1 produces the triangle, iterates each row and prints it.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
pascal_row([V], [V]).                           % No more value pairs to add
pascal_row([V0, V1|T], [V|Rest]) :-             % Add values from preceding row
    V is V0 + V1, !, pascal_row([V1|T], Rest).  % Drops initial value (1).

pascal(1, [1], []).    % at depth 1, this row is [1] and no preceding rows.
pascal(N, [1|ThisRow], [Last|Preceding]) :- % Produce a row of depth N
    succ(N0, N),                            % N is the successor to N0
    pascal(N0, Last, Preceding),            % Get the previous row
    !, pascal_row(Last, ThisRow).           % Calculate this row from the previous

pascal(N, Triangle) :-
   pascal(N, Last, Rows),             % Retrieve row at depth N and preceding rows
   !, reverse([Last|Rows], Triangle). % Add last row to triangle and reverse order

pascal(N) :-
  pascal(N, Triangle), member(Row, Triangle), % Iterate and write each row
  write(Row), nl, fail.
pascal(_).
