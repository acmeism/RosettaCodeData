-module(knapsack_0_1).

-export([go/0,
         solve/5]).

-define(STUFF,
        [{"map",                      9,   150},
         {"compass",                 13,    35},
         {"water",                  153,   200},
         {"sandwich",                50,   160},
         {"glucose",                 15,    60},
         {"tin",                     68,    45},
         {"banana",                  27,    60},
         {"apple",                   39,    40},
         {"cheese",                  23,    30},
         {"beer",                    52,    10},
         {"suntan cream",            11,    70},
         {"camera",                  32,    30},
         {"T-shirt",                 24,    15},
         {"trousers",                48,    10},
         {"umbrella",                73,    40},
         {"waterproof trousers",     42,    70},
         {"waterproof overclothes",  43,    75},
         {"note-case",               22,    80},
         {"sunglasses",               7,    20},
         {"towel",                   18,    12},
         {"socks",                    4,    50},
         {"book",                    30,    10}
        ]).

-define(MAX_WEIGHT, 400).

go() ->
    StartTime = os:timestamp(),
    {ItemList, TotalValue, TotalWeight} =
        solve(?STUFF, ?MAX_WEIGHT, [], 0, 0),
    TimeElapsed = timer:now_diff(os:timestamp(), StartTime),
    io:format("Items: ~n"),
    [io:format("~p~n", [Item]) || Item <- ItemList],
    io:format(
      "Total value: ~p~nTotal weight: ~p~nTime elapsed in milliseconds: ~p~n",
      [TotalValue, TotalWeight, TimeElapsed/1000]).

solve([], _TotalWeight, ItemAcc, ValueAcc, WeightAcc) ->
    {ItemAcc, ValueAcc, WeightAcc};
solve([{_Item, ItemWeight, _ItemValue} | T],
      TotalWeight,
      ItemAcc,
      ValueAcc,
      WeightAcc) when ItemWeight > TotalWeight ->
    solve(T, TotalWeight, ItemAcc, ValueAcc, WeightAcc);
solve([{ItemName, ItemWeight, ItemValue} | T],
      TotalWeight,
      ItemAcc,
      ValueAcc,
      WeightAcc) ->
    {_TailItemAcc, TailValueAcc, _TailWeightAcc} = TailRes =
        solve(T, TotalWeight, ItemAcc, ValueAcc, WeightAcc),
    {_HeadItemAcc, HeadValueAcc, _HeadWeightAcc} = HeadRes =
        solve(T,
              TotalWeight - ItemWeight,
              [ItemName | ItemAcc],
              ValueAcc + ItemValue,
              WeightAcc + ItemWeight),

    case TailValueAcc > HeadValueAcc of
        true ->
            TailRes;
        false ->
            HeadRes
    end.
