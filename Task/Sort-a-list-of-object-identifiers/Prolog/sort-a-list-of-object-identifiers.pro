main:-
    sort_oid_list(["1.3.6.1.4.1.11.2.17.19.3.4.0.10",
    "1.3.6.1.4.1.11.2.17.5.2.0.79",
    "1.3.6.1.4.1.11.2.17.19.3.4.0.4",
    "1.3.6.1.4.1.11150.3.4.0.1",
    "1.3.6.1.4.1.11.2.17.19.3.4.0.1",
    "1.3.6.1.4.1.11150.3.4.0"], Sorted_list),
    foreach(member(oid(_, Oid), Sorted_list), writeln(Oid)).

sort_oid_list(Oid_list, Sorted_list):-
    parse_oid_list(Oid_list, Parsed),
    sort(1, @=<, Parsed, Sorted_list).

parse_oid_list([], []):-!.
parse_oid_list([Oid|Oid_list], [oid(Numbers, Oid)|Parsed]):-
    parse_oid(Oid, Numbers),
    parse_oid_list(Oid_list, Parsed).

parse_oid(Oid, Numbers):-
    split_string(Oid, ".", ".", Strings),
    number_strings(Numbers, Strings).

number_strings([], []):-!.
number_strings([Number|Numbers], [String|Strings]):-
    number_string(Number, String),
    number_strings(Numbers, Strings).
