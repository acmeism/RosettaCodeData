?- [plffi].
% plffi compiled into plffi 0.04 sec, 1,477 clauses
true.

?- strdup('Booger!', X).
X = 'Booger!'.

?- strdup(booger, X).
X = booger.

?- strdup(booger, booger).
true.

?- X = booger, strdup(booger, X).
X = booger.
