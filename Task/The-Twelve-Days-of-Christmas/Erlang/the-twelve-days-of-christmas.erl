-module(twelve_days).
-export([gifts_for_day/1]).

names(N) -> lists:nth(N,
              ["first",   "second", "third", "fourth", "fifth",    "sixth",
               "seventh", "eighth", "ninth", "tenth",  "eleventh", "twelfth" ]).

gifts() -> [ "A partridge in a pear tree.", "Two turtle doves and",
             "Three French hens,",          "Four calling birds,",
             "Five gold rings,",            "Six geese a-laying,",
             "Seven swans a-swimming,",     "Eight maids a-milking,",
             "Nine ladies dancing,",        "Ten lords a-leaping,",
             "Eleven pipers piping,",       "Twelve drummers drumming," ].

gifts_for_day(N) ->
  "On the " ++ names(N) ++ " day of Christmas, my true love sent to me:\n" ++
  string:join(lists:reverse(lists:sublist(gifts(), N)), "\n").

main(_) -> lists:map(fun(N) -> io:fwrite("~s~n~n", [gifts_for_day(N)]) end,
                     lists:seq(1,12)).
