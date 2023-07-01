count_substring(String, Sub, Total) :-
    count_substring(String, Sub, 0, Total).

count_substring(String, Sub, Count, Total) :-
    ( substring_rest(String, Sub, Rest)
    ->
        succ(Count, NextCount),
        count_substring(Rest, Sub, NextCount, Total)
    ;
        Total = Count
    ).

substring_rest(String, Sub, Rest) :-
    sub_string(String, Before, Length, Remain, Sub),
    DropN is Before + Length,
    sub_string(String, DropN, Remain, 0, Rest).
