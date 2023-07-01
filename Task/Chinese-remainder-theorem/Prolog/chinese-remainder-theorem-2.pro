/* Chinese remainder Theorem: Input chinrest([2,3,2], [3,5,7], R).  -----> R == 23
                                 or chinrest([2,3], [5,13], R). ---------> R == 42
    Written along the lines of "Introduction to Algorithms" by
    Thomas Cormen
    Charles Leiserson
    Ronald Rivest
compiled with gprolog 1.4.5 (64 Bits)
*/

chinrest(A, N, X) :-
    sort(N),
    prime(N,Nn), !, lenok(A, Nn),                         /* test as to whether the ni are primes */
    product(Nn,P), !,                                     /* P is the product of the ni */
    milist(P, Nn, Mi),                                    /* The Mi List: mi = n/ni */
    cilist(Mi, Nn, Ci),                                   /* The first Ci List: mi-1 mod ni */
    mult_lists(Mi, Ci, Ac),                               /* The ci List :mi*(mi-1 mod ni) */
    mult_lists(Ac, A, Ad),                                /* The ai*ci List */
    sum_list(Ad, S),                                      /* Sum of the ai*cis */
    X is S mod P, ! .                                     /* a is (a1c1 + ... +akck) mod n */

prime([X|Ys], Zs) :- fd_not_prime(X), !, prime(Ys,Zs).    /* sift the primes of [list] */
prime([Y|Ys], [Y|Zs]) :- fd_prime(Y), !, prime(Ys,Zs).
prime([],[]).

product([], 0).                                           /* n1.n2.n3. ... .ni. ... .nk */
product([H|T], P) :- product_1(T, H, P).

product_1([], P, P).
product_1([H|T], H0, P) :- product_1(T, H, P0), P is P0 * H0.

lenok(A, N) :- length(A, X), length(N, Y), X=:=Y.
lenok(_, _) :- write('Please enter equal length prime numbers only'), fail.

cilist(Mi, Ni, Ci) :- maplist( (modinv), Mi, Ni, Ci).       /* generate the Cis */

mult_lists(Ai, Ci, Ac) :- maplist( (pro), Ai, Ci, Ac).      /* The mi*ci */
pro(X, Y, Z) :- Z is X * Y.

milist(_, [],[]).
milist(P, [H|T],[X|Y]) :- X is truncate(P/H), milist(P, T, Y).

modinv(A, B, N) :- eeuclid(A, B, P, _, GCD),
        GCD =:= 1,
        N is P mod B.

eeuclid(A,B,P,S,GCD) :-
   A >= B,
   a_b_p_s_(A,B,P,S,1-0,0-1,GCD),
   GCD is A*P + B*S.

eeuclid(A,B,P,S,GCD) :-
   A < B,
   a_b_p_s_(B,A,S,P,1-0,0-1,GCD);
   GCD is A*P + B*S.

a_b_p_s_(A,0,P1,S1,P1-_P2,S1-_S2,A).
a_b_p_s_(A,B,P,S,P1-P2,S1-S2,GCD) :-
   B > 0,
   A > B,
   Q is truncate(A/B),
   B1 is A mod B,
   P3 is P1-(Q*P2),
   S3 is S1-(Q*S2),
   a_b_p_s_(B,B1,P,S,P2-P3,S2-S3,GCD).
