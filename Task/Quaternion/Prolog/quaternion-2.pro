data(q,  qx(1,2,3,4)).
data(q1, qx(2,3,4,5)).
data(q2, qx(3,4,5,6)).
data(r, 7).

test :-	data(Name, qx(A,B,C,D)), abs(qx(A,B,C,D), Norm),
	writef('abs(%w) is %w\n', [Name, Norm]), fail.
test :- data(q, Qx), negate(Qx, Nqx),
	writef('negate(%w) is %w\n', [q, Nqx]), fail.
test :- data(q, Qx), conjugate(Qx, Nqx),
	writef('conjugate(%w) is %w\n', [q, Nqx]), fail.
test :- data(q1, Q1), data(q2, Q2), add(Q1, Q2, Qx),
	writef('q1+q2 is %w\n', [Qx]), fail.
test :- data(q1, Q1), data(q2, Q2), add(Q2, Q1, Qx),
	writef('q2+q1 is %w\n', [Qx]), fail.
test :- data(q, Qx), data(r, R), mul(Qx, R, Nqx),
	writef('q*r is %w\n', [Nqx]), fail.
test :- data(q, Qx), data(r, R), mul(R, Qx, Nqx),
	writef('r*q is %w\n', [Nqx]), fail.
test :- data(q1, Q1), data(q2, Q2), mul(Q1, Q2, Qx),
	writef('q1*q2 is %w\n', [Qx]), fail.
test :- data(q1, Q1), data(q2, Q2), mul(Q2, Q1, Qx),
	writef('q2*q1 is %w\n', [Qx]), fail.
test.
