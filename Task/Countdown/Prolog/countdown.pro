/* given numbers & target */

n(100,1). n(75,2). n(50,3). n(25,4). n(6,5). n(3,6).
ok(Res) :- Res = 952.

/* four operations with strictly positive integers and N1 >= N2 */

r(N1,N2,Res,'+') :-                         Res is N1 + N2.
r(N1,N2,Res,'-') :- N1 > N2,                Res is N1 - N2.
r(N1,N2,Res,'*') :- N2 > 1,                 Res is N1 * N2.
r(N1,N2,Res,'/') :- N2 > 1, 0 is N1 mod N2, Res is N1 div N2.

/* concatenation */

concaten([],L,L).
concaten([H|L1],L2,[H|L3]) :- concaten(L1,L2,L3).

/* four operations & print solution management */

ra(N1,N2,Res,Lout1,Lout2,NewLout) :-
   concaten(Lout1,Lout2,Lout),
   N1 >= N2,
   r(N1,N2,Res,Ope),
   concaten(Lout,[N1,Ope,N2,Res|[]],NewLout).

/* print result */

lout([]) :- nl.
lout([N1,Ope,N2,Res|Queue]) :-
   out(N1,Ope,N2,Res),
   lout(Queue).
out(N1,Ope,N2,Res) :-
   write(N1), write(Ope), write(N2), write('='), write(Res), nl.

/* combine two last numbers & result control */

c(N1,N2,Lout1,Lout2) :-
   ra(N1,N2,Res,Lout1,Lout2,NewLout),
   ok(Res),
   lout(NewLout).

/* unique list */

uniqueList([]).
uniqueList([H|T]) :- \+(member(H,T)), uniqueList(T).

/* all possible arrangements */

c1 :-
   n(Nb,_),                                             /* a                  */
   ok(Nb),
   write(Nb).

c2 :-
   n(N1,I1), n(N2,I2),                                  /* (ab)               */
   I1\=I2,
        c(N1,N2,[],[]).

c3 :-
   n(N1,I1), n(N2,I2), n(N3,I3),
   I1\=I2, I1\=I3, I2\=I3,
       ra(N1,  N2,  Res1,[],   [],   Lout1),            /* (ab) c             */
        c(Res1,N3,       Lout1,[]).

c4 :-
   n(N1,I1), n(N2,I2), n(N3,I3), n(N4,I4),
   uniqueList([I1,I2,I3,I4]),
       ra(N1,  N2,  Res1,[],   [],   Lout1),            /* (ab) (cd)          */
   ((  ra(N3,  N4,  Res2,[],   [],   Lout2),
        c(Res1,Res2,     Lout1,Lout2));                 /* ((ab) c) d         */
   (   ra(Res1,N3,  Res2,Lout1,[],   Lout2),
        c(Res2,N4,       Lout2,[]))).

c5 :-
   n(N1,I1), n(N2,I2), n(N3,I3), n(N4,I4), n(N5,I5),
   uniqueList([I1,I2,I3,I4,I5]),
       ra(N1,  N2,  Res1,[],   [],   Lout1),            /* ((ab) (cd)) e      */
   ((  ra(N3,  N4,  Res2,[],   [],   Lout2),
       ra(Res1,Res2,Res3,Lout1,Lout2,Lout3),
        c(Res3,N5,       Lout3,[]));                    /* ((ab) c) (de)      */
   (   ra(Res1,N3,  Res2,Lout1,[],   Lout2),
       ra(N4,  N5,  Res3,[],   [],   Lout3),
        c(Res2,Res3,     Lout2,Lout3));                 /* (((ab) c) d) e     */
   (   ra(Res1,N3,  Res2,Lout1,[],   Lout2),
       ra(Res2,N4,  Res3,Lout2,[],   Lout3),
        c(Res3,N5,       Lout3,[]))).

c6 :-
   n(N1,I1), n(N2,I2), n(N3,I3), n(N4,I4), n(N5,I5), n(N6,I6),
   uniqueList([I1,I2,I3,I4,I5,I6]),
       ra(N1,  N2,  Res1,[],   [],   Lout1),            /* ((ab) (cd)) (ef)   */
   ((  ra(N3,  N4,  Res2,[],   [],   Lout2),
       ra(Res1,Res2,Res3,Lout1,Lout2,Lout3),
       ra(N5,  N6,  Res4,[],   [],   Lout4),
        c(Res3,Res4,     Lout3,Lout4));                 /* ((ab) c) ((de) f)  */
   (   ra(Res1,N3,  Res2,Lout1,[],   Lout2),
       ra(N4,  N5,  Res3,[],   [],   Lout3),
       ra(Res3,N6,  Res4,Lout3,[],   Lout4),
        c(Res2,Res4,     Lout2,Lout4));                 /* (((ab) c) d) (ef)  */
   (   ra(Res1,N3,  Res2,Lout1,[],   Lout2),
       ra(Res2,N4,  Res3,Lout2,[],   Lout3),
       ra(N5,  N6,  Res4,[],   [],   Lout4),
        c(Res3,Res4,     Lout3,Lout4));                 /* ((((ab) c) d) e) f */
   (   ra(Res1,N3,  Res2,Lout1,[],   Lout2),
       ra(Res2,N4,  Res3,Lout2,[],   Lout3),
       ra(Res3,N5,  Res4,Lout3,[],   Lout4),
        c(Res4,N6,       Lout4,[]))).

/* solution */

solution :- c1 ; c2 ; c3 ; c4 ; c5 ; c6.
