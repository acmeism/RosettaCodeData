% Erlang implementation of Vigenère cipher
-module(vigenere).
-export([encrypt/2, decrypt/2]).
-import(lists, [append/2, filter/2, map/2, zipwith/3]).

% Utility functions for character tests and conversions
isupper([C|_]) -> isupper(C);
isupper(C)     -> (C >= $A) and (C =< $Z).

islower([C|_]) -> islower(C);
islower(C)     -> (C >= $a) and (C =< $z).

isalpha([C|_]) -> isalpha(C);
isalpha(C)     -> isupper(C) or islower(C).

toupper(S) when is_list(S) -> lists:map(fun toupper/1, S);
toupper(C) when (C >= $a) and (C =< $z) -> C - $a + $A;
toupper(C) -> C.

% modulo function that normalizes into positive range for positive divisor
mod(X,Y) -> (X rem Y + Y) rem Y.

% convert letter to position in alphabet (A=0,B=1,...,Y=24,Z=25).
to_pos(L) when L >= $A, L =< $Z -> L - $A.

% convert position in alphabet back to letter
from_pos(N) -> mod(N, 26) + $A.

% encode the given letter given the single-letter key
encipher(P, K) -> from_pos(to_pos(P) + to_pos(K)).

% decode the given letter given the single-letter key
decipher(C, K) -> from_pos(to_pos(C) - to_pos(K)).

% extend a list by repeating it until it is at least N elements long
cycle_to(N, List) when length(List) >= N -> List;
cycle_to(N, List) -> append(List, cycle_to(N-length(List), List)).

% Encryption prep: reduce string to only its letters, in uppercase
normalize(Str) -> toupper(filter(fun isalpha/1, Str)).

crypt(RawText, RawKey, Func) ->
  PlainText = normalize(RawText),
  zipwith(Func, PlainText, cycle_to(length(PlainText), normalize(RawKey))).

encrypt(Text, Key) -> crypt(Text, Key, fun encipher/2).
decrypt(Text, Key) -> crypt(Text, Key, fun decipher/2).
