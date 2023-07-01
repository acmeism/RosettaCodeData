-module( hash_join ).

-export( [task/0] ).

task() ->
    Table_1 = [{27, "Jonah"}, {18, "Alan"}, {28, "Glory"}, {18, "Popeye"}, {28, "Alan"}],
    Table_2 = [{"Jonah", "Whales"}, {"Jonah", "Spiders"}, {"Alan", "Ghosts"}, {"Alan", "Zombies"}, {"Glory", "Buffy"}],
    Dict = lists:foldl( fun dict_append/2, dict:new(), Table_1 ),
    lists:flatten( [dict_find( X, Dict ) || X <- Table_2] ).


dict_append( {Key, Value}, Acc ) -> dict:append( Value, {Key, Value}, Acc ).

dict_find( {Key, Value}, Dict ) -> dict_find( dict:find(Key, Dict), Key, Value ).

dict_find( error, _Key, _Value ) -> [];
dict_find( {ok,	Values}, Key, Value ) -> [{X, {Key, Value}} || X <- Values].
