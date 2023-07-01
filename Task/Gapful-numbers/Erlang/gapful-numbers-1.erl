-module(gapful).
-export([first_digit/1, last_digit/1, bookend_number/1, is_gapful/1]).

first_digit(N) ->
  list_to_integer(string:slice(integer_to_list(N),0,1)).

last_digit(N) -> N rem 10.

bookend_number(N) -> 10 * first_digit(N) + last_digit(N).

is_gapful(N) -> (N >= 100) and (0 == N rem bookend_number(N)).
