:- table ack/3. % memoization reduces the execution time of ack(4,1,X) from several
                % minutes to about one second on a typical desktop computer.
ack(0, N, Ans) :- Ans is N+1.
ack(M, 0, Ans) :- M>0, X is M-1, ack(X, 1, Ans).
ack(M, N, Ans) :- M>0, N>0, X is M-1, Y is N-1, ack(M, Y, Ans2), ack(X, Ans2, Ans).
