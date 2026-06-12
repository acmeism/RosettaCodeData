-module(fifth_powers).
-export([main/0, sum_of_fifth_powers/1, digits/1]).

% Function to calculate the sum of the fifth powers of the digits of a number
sum_of_fifth_powers(N) ->
    Digits = digits(N),
    lists:sum([math:pow(Digit, 5) || Digit <- Digits]).

% Helper function to convert a number into a list of its digits
digits(N) ->
    list_to_digits(integer_to_list(N)).

% Convert each character of the string into a list of digits
list_to_digits(Str) ->
    [char_to_digit([Char]) || Char <- Str].

% Convert a character to an integer
char_to_digit([Char]) when Char >= $0, Char =< $9 -> Char - $0.

% Main function to compute the sum of all numbers that satisfy the condition
main() ->
    UpperLimit = 6 * trunc(math:pow(9, 5)), % Calculate the upper limit 6 * 9^5
    Numbers = lists:seq(2, UpperLimit),
    ValidNumbers = [N || N <- Numbers, sum_of_fifth_powers(N) == N],
    lists:sum(ValidNumbers).


