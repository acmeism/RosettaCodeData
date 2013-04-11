list_max([Head|Rest]) ->
  list_max(Rest, Head).

list_max([], Res) -> Res;
list_max([Head|Rest], Max) when Head > Max ->
  list_max(Rest, Head);
list_max([_Head|Rest], Max)  -> list_max(Rest, Max).
