-module(stack).
-export([empty/1, new/0, pop/1, push/2, top/1]).

new() -> [].

empty([]) -> true;
empty(_) -> false.

pop([H|T]) -> {H,T}.

push(H,T) -> [H|T].

top([H|_]) -> H.
