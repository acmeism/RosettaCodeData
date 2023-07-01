sum_3_5(X) when is_number(X) -> sum_3_5(erlang:round(X)-1, 0).
sum_3_5(X, Total) when X < 3 -> Total;
sum_3_5(X, Total) when X rem 3 =:= 0 orelse X rem 5 =:= 0 ->
  sum_3_5(X-1, Total+X);
sum_3_5(X, Total) ->
  sum_3_5(X-1, Total).

io:format("~B~n", [sum_3_5(1000)]).
