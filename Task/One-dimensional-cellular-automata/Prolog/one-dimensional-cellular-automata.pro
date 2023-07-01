one_dimensional_cellular_automata(L) :-
	maplist(my_write, L), nl,
	length(L, N),
	length(LN, N),
	% there is a 0 before the beginning
	compute_next([0 |L], LN),
	(   L \= LN -> one_dimensional_cellular_automata(LN); true).

% All the possibilites
compute_next([0, 0, 0 | R], [0 | R1]) :-
	compute_next([0, 0 | R], R1).

compute_next([0, 0, 1 | R], [0 | R1]) :-
	compute_next([0, 1 | R], R1).

compute_next([0, 1, 0 | R], [0 | R1]) :-
	compute_next([1, 0 | R], R1).

compute_next([0, 1, 1 | R], [1 | R1]) :-
	compute_next([1, 1 | R], R1).

compute_next([1, 0, 0 | R], [0 | R1]) :-
	compute_next([0, 0 | R], R1).

compute_next([1, 0, 1 | R], [1 | R1]) :-
	compute_next([0, 1 | R], R1).

compute_next([1, 1, 0 | R], [1 | R1]) :-
	compute_next([1, 0 | R], R1).

compute_next([1, 1, 1 | R], [0 | R1]) :-
	compute_next([1, 1 | R], R1).

% the last four possibilies =>
% we consider that there is à 0  after the end
complang jq># The 1-d cellular automaton:
def next:
   # Conveniently, jq treats null as 0 when it comes to addition
   # so there is no need to fiddle with the boundaries
  . as $old
  | reduce range(0; length) as $i
    ([];
     ($old[$i-1] + $old[$i+1]) as $s
     | if   $s == 0 then .[$i] = 0
       elif $s == 1 then .[$i] = (if $old[$i] == 1 then 1 else 0 end)
       else              .[$i] = (if $old[$i] == 1 then 0 else 1 end)
       end);


# pretty-print an array:
def pp: reduce .[] as $i (""; . + (if $i == 0 then " " else "*" end));

# continue until quiescence:
def go: recurse(. as $prev | next | if . == $prev then empty else . end) | pp;

# Example:
[0,1,1,1,0,1,1,0,1,0,1,0,1,0,1,0,0,1,0,0] | goute_next([0, 0], [0]).

compute_next([1, 0], [0]).

compute_next([0, 1], [0]).

compute_next([1, 1], [1]).

my_write(0) :-
	write(.).

my_write(1) :-
	write(#).

one_dimensional_cellular_automata :-
	L = [0,1,1,1,0,1,1,0,1,0,1,0,1,0,1,0,0,1,0,0],
	one_dimensional_cellular_automata(L).
