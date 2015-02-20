% 8 queens problem.
%  q(Row) represents a queen, allocated one per row. No rows ever clash.
%  The columns are chosen iteratively from available columns held in a
%  list, reduced with each allocation, so we need never check verticals.
%  For diagonals, we check prior to allocation whether each newly placed
%  queen will clash with any of the prior placements. This prevents
%  most invalid permutations from ever being attempted.
can_place(_, []) :- !.	   % success for empty board
can_place(q(R,C),Board) :- % check diagonals against allocated queens
	member(q(Ra,Ca), Board), abs(Ra-R) =:= abs(Ca-C), !, fail.
can_place(_,_).            % succeed if no diagonals failed

queens([], [], Board, Board).                            % found a solution
queens([q(R)|Queens], Columns, Board, Solution) :-
	nth0(_,Columns,C,Free), can_place(q(R,C),Board), % find all solutions
	queens(Queens,Free,[q(R,C)|Board], Solution).    % recursively

queens :-
  findall(q(N), between(0,7,N), Queens), findall(N, between(0,7,N), Columns),
  findall(B, queens(Queens, Columns, [], B), Boards),     % backtrack over all
  length(Boards, Len), writef('%w solutions:\n', [Len]),  % Output solutions
  member(R,Boards), reverse(R,Board), writef('  - %w\n', [Board]), fail.
queens.
