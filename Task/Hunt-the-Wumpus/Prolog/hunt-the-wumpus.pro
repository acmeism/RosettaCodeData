/**
 * Simple text based dungeon game in Prolog.
 *
 * Warranty & Liability
 * To the extent permitted by applicable law and unless explicitly
 * otherwise agreed upon, XLOG Technologies GmbH makes no warranties
 * regarding the provided information. XLOG Technologies GmbH assumes
 * no liability that any problems might be solved with the information
 * provided by XLOG Technologies GmbH.
 *
 * Rights & License
 * All industrial property rights regarding the information - copyright
 * and patent rights in particular - are the sole property of XLOG
 * Technologies GmbH. If the company was not the originator of some
 * excerpts, XLOG Technologies GmbH has at least obtained the right to
 * reproduce, change and translate the information.
 *
 * Reproduction is restricted to the whole unaltered document. Reproduction
 * of the information is only allowed for non-commercial uses. Selling,
 * giving away or letting of the execution of the library is prohibited.
 * The library can be distributed as part of your applications and libraries
 * for execution provided this comment remains unchanged.
 *
 * Restrictions
 * Only to be distributed with programs that add significant and primary
 * functionality to the library. Not to be distributed with additional
 * software intended to replace any components of the library.
 *
 * Trademarks
 * Jekejeke is a registered trademark of XLOG Technologies GmbH.
 */

/**
 * Obtained rights, copyright notice of BASIC version found
 * in The Best of Creative Computing Volume 1 (published 1976)
 * https://www.atariarchives.org/bcc1/showpage.php?page=247
 * and that we translated to Prolog.
 *
 * 0010  REM- HUNT THE WUMPUS
 * 0015  REM:  BY GREGORY YOB
 *
 * Game must have been create before, we assume 1972 since
 * the German Wikipedia mentions this date. The Englis Wikipedia
 * refers probably to a TI-99/4A version from 1973.
 */

:- module(wumpus, [wumpus/0]).

:- use_module(console).
:- use_module(library(advanced/arith)).
:- use_module(library(basic/lists)).
:- use_module(library(basic/random)).

% wumpus
wumpus :- preamble,
   locate(L),
   play(L).

% originally: 0350  REM-SET# ARROWS
% play(+List)
play(L) :-
   write('HUNT THE WUMPUS'), nl,
   play(L, L, 5).

% 0400  REM-MOVE OR SHOOT
% play(+List, +List, +Integer)
play(M, L, A) :-
   location(L),
   choose(O),
   (  O = 2
   -> move(L, H),
      check(H, R, F),
      B = A
   ;  rooms(N),
      path(N, [], P),
      shoot(P, L, A, R, B, F)),
   result(F, M, R, B).

% result(+Integer, +List, +List, +Integer)
result(0, M, L, A) :- !,
   play(M, L, A).
result(F, M, _, _) :-
   (  F = -1
   -> write('HA HA HA - YOU LOSE!'), nl
   ;  write('HEE HEE HEE - THE WUMPUS''LL GETCHA NEXT TIME!!'), nl),
   write('SAME SET-UP (Y-N)? '), flush_output,
   read_line(I),
   (  I \== 'Y'
   -> locate(L)
   ;  L = M),
   play(L).

% originally: 2500  REM-CHOOSE OPTION
% choose(-Integer)
choose(O) :- repeat,
   write('SHOOT OR MOVE (S-M)? '), flush_output,
   read_line(I),
   (  'S' = I
   -> O = 1
   ;  'M' = I
   -> O = 2; fail), !.

/************************************************************/
/* Move                                                     */
/************************************************************/

% originally: 4000  REM- MOVE ROUTINE
% move(+List, -List)
move([X|L], [P|L]) :- repeat,
   write('WHERE TO? '), flush_output,
   read_line(H),
   atom_number(H, P),
   1 =< P,
   P =< 20,
   (  edge(X, P) -> true
   ;  P = X -> true
   ;  write('NOT POSSIBLE - '), fail), !.

% originally: 4120  REM-CHECK FOR HAZARDS
% check(+List, -List, -Integer)
check([X,Y|L], R, F) :-
   X = Y, !,
   write('...OOPS! BUMPED A WUMPUS!'), nl,
   bump([X,Y|L], R, F).
check([X,_,Z,T,_,_], _, -1) :-
   (  X = Z
   ;  X = T), !,
   write('YYYIIIIEEEE . . . FELL IN PIT'), nl.
check([X,Y,Z,T,U,V], L, F) :-
   (  X = U
   ;  X = V), !,
   write('ZAP--SUPER BAT SNATCH! ELSEWHEREVILLE FOR YOU!'), nl,
   fna(P),
   check([P,Y,Z,T,U,V], L, F).
check(L, L, 0).

% originally: 3370  REM-MOVE WUMPUS ROUTINE
% bump(+List, -List, -Integer)
bump([X,Y|L], [X,P|L], F) :-
   fnc(C),
   (  C = 4
   -> P = Y
   ;  findall(P, edge(Y, P), H),
      nth1(C, H, P)),
   (  X = P
   -> write('TSK TSK TSK- WUMPUS GOT YOU!'), nl,
      F = -1
   ;  F = 0).

/************************************************************/
/* Shoot                                                    */
/************************************************************/

% shoot(+List, +List, +Integer, -List, -Integer, -Integer)
shoot(P, [X|L], A, R, B, G) :-
   arrow(P, X, [X|L], F),
   missed(F, [X|L], A, R, B, G).

% missed(+Integer, +List, +Integer, -List, -Integer, -Integer)
missed(0, L, A, R, B, F) :- !,
   write('MISSED'), nl,
   bump(L, R, G),
   ammo(G, A, B, F).
missed(F, L, A, L, A, F).

% originally: 3250  REM-AMMO CHECK
% ammo(+Integer, +Integer, -Integer, -Integer)
ammo(0, A, B, F) :- !,
   B is A-1,
   (  B = 0
   -> F = -1
   ;  F = 0).
ammo(F, A, A, F).

% originally: 3120  REM-SHOOT ARROW
% arrow(+List, +Integer, +List, -Integer)
arrow([], _, _, 0).
arrow([Y|P], X, L, F) :-
   follow(X, Y, Z),
   hit(Z, L, P, F).

% follow(+Integer, +Integer, -Integer)
follow(X, Y, Z) :-
   edge(X, Y), !,
   Z = Y.
follow(X, _, Z) :-
   fnb(C),
   findall(Z, edge(X, Z), H),
   nth1(C, H, Z).

% originally: 3290  REM-SEE IF ARROW IS AT L(1) OR L(2)
% hit(+Integer, +List, +List, -Integer)
hit(Z, [_,Y|_], _, 1) :-
   Z = Y, !,
   write('AHA! YOU GOT THE WUMPUS!'), nl.
hit(Z, [X|_], _, -1) :-
   Z = X, !,
   write('OUCH! ARROW GOT YOU!'), nl.
hit(Z, L, P, F) :-
   arrow(P, Z, L, F).

% originally: 3020  REM-PATH OF ARROW
% rooms(-Integer)
rooms(N) :- repeat,
   write('NO. OF ROOMS(1-5)? '), flush_output,
   read_line(H),
   atom_number(H, N),
   1 =< N,
   N =< 5, !.

% path(+Integer, +List, -List)
path(0, _, []) :- !.
path(N, L, [P|R]) :- repeat,
   write('ROOM #? '), flush_output,
   read_line(H),
   atom_number(H, P),
   (  L = [_,Q|_],
      Q = P
   -> write('ARROWS AREN''T THAT CROOKED - TRY ANOTHER ROOM'), nl, fail; true), !,
   M is N-1,
   path(M, [P|L], R).

/************************************************************/
/* Dungeon                                                  */
/************************************************************/

% originally: 2000  REM-PRINT LOCATION & HAZARD WARNINGS
% location(+List)
location([X,Y,Z,T,U,V]) :-
   (  edge(X, Y)
   -> write('I SMELL A WUMPUS!'), nl; true),
   (  (  edge(X, Z)
      ;  edge(X, T))
   -> write('I FEEL A DRAFT'), nl; true),
   (  (  edge(X, U)
      ;  edge(X, V))
   -> write('BATS NEARBY'), nl; true),
   write('YOU ARE IN ROOM '),
   write(X), nl,
   write('TUNNELS LEAD TO'),
   (  edge(X, R),
      write(' '),
      write(R), fail; true), nl.

% originally: 0200  REM-LOCATE L ARRAY ITEMS
% originally: 0210  REM-1-YOU,2-WUMPUS,3&4-PITS,5&6-BATS
% locate(-List)
locate(L) :-
   length(L, 6), repeat,
   maplist(fna, L),
   \+ (  append(R, [X|_], L),
         member(X, R)), !.

% fna(-Integer)
fna(X) :-
   X is random(20)+1.
% fnb(-Integer)
fnb(X) :-
   X is random(3)+1.
% fnc(-Integer)
fnc(X) :-
   X is random(4)+1.

% Originally: 0068  REM- SET UP CAVE (DODECAHEDRAL NODE LIST)
% edge(-Integer, -Integer)
edge(1, 2).
edge(1, 5).
edge(1, 8).
edge(2, 1).
edge(2, 3).
edge(2, 10).
edge(3, 2).
edge(3, 4).
edge(3, 12).
edge(4, 3).
edge(4, 5).
edge(4, 14).
edge(5, 1).
edge(5, 4).
edge(5, 6).
edge(6, 5).
edge(6, 7).
edge(6, 15).
edge(7, 6).
edge(7, 8).
edge(7, 17).
edge(8, 1).
edge(8, 7).
edge(8, 9).
edge(9, 8).
edge(9, 10).
edge(9, 18).
edge(10, 2).
edge(10, 9).
edge(10, 11).
edge(11, 10).
edge(11, 12).
edge(11, 19).
edge(12, 3).
edge(12, 11).
edge(12, 13).
edge(13, 12).
edge(13, 14).
edge(13, 20).
edge(14, 4).
edge(14, 13).
edge(14, 15).
edge(15, 6).
edge(15, 14).
edge(15, 16).
edge(16, 15).
edge(16, 17).
edge(16, 20).
edge(17, 7).
edge(17, 16).
edge(17, 18).
edge(18, 9).
edge(18, 17).
edge(18, 19).
edge(19, 11).
edge(19, 18).
edge(19, 20).
edge(20, 13).
edge(20, 16).
edge(20, 19).

/************************************************************/
/* Instructions                                             */
/************************************************************/

% Originally: 1000  REM-INSTRUCTIONS
% preamble
preamble :-
   write('INSTRUCTIONS (Y-N)? '), flush_output,
   read_line(I),
   (  I \== 'N' -> instructions; true).

% instructions
instructions :-
   write('WELCOME TO ''HUNT THE WUMPUS'''), nl,
   write('  THE WUMPUS LIVES IN A CAVE OF 20 ROOMS. EACH ROOM'), nl,
   write('HAS 3 TUNNELS LEADING TO OTHER ROOMS. (LOOK AT A'), nl,
   write('DODECAHEDRON TO SEE HOW THIS WORKS-IF YOU DON''T KNOW'), nl,
   write('WHAT A DODECAHEDRON IS, ASK SOMEONE)'), nl, nl,
   write('     HAZARDS:'), nl,
   write(' BOTTOMLESS PITS - TWO ROOMS HAVE BOTTOMLESS PITS IN THEM'), nl,
   write('     IF YOU GO THERE, YOU FALL INTO THE PIT (& LOSE!)'), nl,
   write(' SUPER BATS - TWO OTHER ROOMS HAVE SUPER BATS. IF YOU'), nl,
   write('     GO THERE, A BAT GRABS YOU AND TAKES YOU TO SOME OTHER'), nl,
   write('     ROOM AT RANDOM. (WHICH MIGHT BE TROUBLESOME)'), nl, nl,
   write('     WUMPUS:'), nl,
   write(' THE WUMPUS IS NOT BOTHERED BY THE HAZARDS (HE HAS SUCKER'), nl,
   write(' FEET AND IS TOO BIG FOR A BAT TO LIFT).  USUALLY'), nl,
   write(' HE IS ASLEEP. TWO THINGS WAKE HIM UP: YOUR ENTERING'), nl,
   write(' HIS ROOM OR YOUR SHOOTING AN ARROW.'), nl,
   write('     IF THE WUMPUS WAKES, HE MOVES (P=.75) ONE ROOM'), nl,
   write(' OR STAYS STILL (P=.25). AFTER THAT, IF HE IS WHERE YOU'), nl,
   write(' ARE, HE EATS YOU UP (& YOU LOSE!)'), nl, nl,
   write('     YOU:'), nl,
   write(' EACH TURN YOU MAY MOVE OR SHOOT A CROOKED ARROW'), nl,
   write('   MOVING: YOU CAN GO ONE ROOM (THRU ONE TUNNEL)'), nl,
   write('   ARROWS: YOU HAVE 5 ARROWS. YOU LOSE WHEN YOU RUN OUT.'), nl,
   write('   EACH ARROW CAN GO FROM 1 TO 5 ROOMS. YOU AIM BY TELLING'), nl,
   write('   THE COMPUTER THE ROOM#S YOU WANT THE ARROW TO GO TO.'), nl,
   write('   IF THE ARROW CAN''T GO THAT WAY (IE NO TUNNEL) IT MOVES'), nl,
   write('   AT RAMDOM TO THE NEXT ROOM.'), nl,
   write('     IF THE ARROW HITS THE WUMPUS, YOU WIN.'), nl,
   write('     IF THE ARROW HITS YOU, YOU LOSE.'), nl, nl,
   write('    WARNINGS:'), nl,
   write('     WHEN YOU ARE ONE ROOM AWAY FROM WUMPUS OR HAZARD,'), nl,
   write('    THE COMPUTER SAYS:'), nl,
   write(' WUMPUS-  ''I SMELL A WUMPUS'''), nl,
   write(' BAT   -  ''BATS NEARBY'''), nl,
write(' PIT   -  ''I FEEL A DRAFT'''), nl, nl.
