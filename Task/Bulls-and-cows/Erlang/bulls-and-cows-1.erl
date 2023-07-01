-module(bulls_and_cows).
-export([generate_secret/0, score_guess/2, play/0]).

% generate the secret code
generate_secret() -> generate_secret([], 4, lists:seq(1,9)).
generate_secret(Secret, 0, _) -> Secret;
generate_secret(Secret, N, Digits) ->
  Next = lists:nth(random:uniform(length(Digits)), Digits),
  generate_secret(Secret ++ [Next], N - 1, Digits -- [Next]).

% evaluate a guess
score_guess(Secret, Guess)
  when length(Secret) =/= length(Guess) -> throw(badguess);
score_guess(Secret, Guess) ->
  Bulls = count_bulls(Secret,Guess),
  Cows = count_cows(Secret, Guess, Bulls),
  [Bulls, Cows].

% count bulls (exact matches)
count_bulls(Secret, Guess) ->
  length(lists:filter(fun(I) -> lists:nth(I,Secret) == lists:nth(I,Guess) end,
                      lists:seq(1, length(Secret)))).

% count cows (digits present but out of place)
count_cows(Secret, Guess, Bulls) ->
   length(lists:filter(fun(I) -> lists:member(I, Guess) end, Secret)) - Bulls.

% play a game
play() -> play_round(generate_secret()).

play_round(Secret) -> play_round(Secret, read_guess()).

play_round(Secret, Guess) ->
  play_round(Secret, Guess, score_guess(Secret,Guess)).

play_round(_, _, [4,0]) ->
  io:put_chars("Correct!\n");

play_round(Secret, _, Score) ->
  io:put_chars("\tbulls:"), io:write(hd(Score)), io:put_chars(", cows:"),
  io:write(hd(tl(Score))), io:put_chars("\n"), play_round(Secret).

read_guess() ->
  lists:map(fun(D)->D-48 end,
    lists:sublist(io:get_line("Enter your 4-digit guess: "), 4)).
