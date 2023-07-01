:- system:set_prolog_flag(double_quotes,codes) .

play(STRINGs)
:-
shuffle(STRINGs,SHUFFLEDs) ,
score(STRINGs,SHUFFLEDs,SCORE) ,
system:format('~s , ~s , (~10r)~n',[STRINGs,SHUFFLEDs,SCORE])
.

test
:-
play("abracadabra") ,
play("seesaw") ,
play("elk") ,
play("grrrrrr") ,
play("up") ,
play("a")
.

%! shuffle(Xs0,Ys) .
%
% The list `Ys` is an random permutation of the list `Xs0` .
% No assumption is made about the nature of each item in the list .
%
% The default seed for randomness provided by the system is truly random .
% Set the seed explicitly with `system:set_random(seed(SEED))` .

:- op(1,'xfy','shuffle_') .

shuffle(Xs0,Ys)
:-
(assign_randomness) shuffle_ (Xs0,Ys0) ,
(sort) shuffle_ (Ys0,Ys1) ,
(remove_randomness) shuffle_ (Ys1,Ys)
.

/*
1. assign an random number to each of the items in the list .
2. sort the list of items according to the random number assigned to each item .
3. remove the random number from each of the items in the list .
*/

(assign_randomness) shuffle_ ([],[]) :- ! .

(assign_randomness) shuffle_ ([X0|Xs0],[sortable(R,X0)|Rs])
:-
system:random(R) ,
(assign_randomness) shuffle_ (Xs0,Rs)
.

(sort) shuffle_ (Rs0,Ss)
:-
prolog:sort(Rs0,Ss)
.

(remove_randomness) shuffle_ ([],[]) :- ! .

(remove_randomness) shuffle_ ([sortable(_R0,X0)|Ss0],[X0|Xs])
:-
(remove_randomness) shuffle_ (Ss0,Xs)
.


%! score(Xs0,Ys0,SCORE) .
%
% `SCORE` is the count of positions in Ys0 that
% have the identical content as
% the content in the same position in Xs0 .

score([],[],0) :- ! .

score([X0|Xs0],[Y0|Ys0],SCORE)
:-
X0 = Y0 ,
! ,
score(Xs0,Ys0,SCORE0) ,
SCORE is SCORE0 + 1
.

score([_|Xs0],[_|Ys0],SCORE)
:-
! ,
score(Xs0,Ys0,SCORE)
.
