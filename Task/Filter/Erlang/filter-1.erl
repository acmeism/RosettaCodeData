Numbers = lists:seq(1, 5).
EvenNumbers = lists:filter(fun (X) -> X rem 2 == 0 end, Numbers).
