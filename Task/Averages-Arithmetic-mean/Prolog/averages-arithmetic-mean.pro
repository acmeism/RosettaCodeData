mean(List, Mean) :-
    length(List, Length),
    sumlist(List, Sum),
    Mean is Sum / Length.
