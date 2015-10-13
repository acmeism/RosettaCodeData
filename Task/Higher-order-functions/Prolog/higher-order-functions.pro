first(Predicate) :- call(Predicate).
second(Argument) :- write(Argument).

:-first(second('Hello World!')).
