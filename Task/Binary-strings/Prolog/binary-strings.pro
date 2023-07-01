% Create a string (no destruction necessary)
?- X = "a test string".
X = "a test string".

% String assignment, there is no assignment but you can unify between variables, also 'String cloning and copying'
?- X = "a test string", X = Y.
X = Y, Y = "a test string".

% String comparison
?- X = "a test string", Y = "a test string", X = Y.
X = Y, Y = "a test string".

?- X = "a test string", Y = "a different string", X = Y.
false.

% Test for empty string, this is the same as string comparison.
?- X = "a test string", Y = "", X = Y.
false.

?- X = "", Y = "", X = Y.
false.

% Append a byte to a string
?- X = "a test string", string_concat(X, "!", Y).
X = "a test string",
Y = "a test string!".

% Extract a substring from a string
?- X = "a test string", sub_string(X, 2, 4, _, Y).
X = "a test string",
Y = "test".

?- X = "a test string", sub_string(X, Before, Len, After, test).
X = "a test string",
Before = 2,
Len = 4,
After = 7 ;
false.

% Replace every occurrence of a byte (or a string) in a string with another string
?- X = "a test string", re_replace('t'/g, 'o', X, Y).
X = "a test string",
Y = "a oeso soring".

% Join strings
?- X = "a test string", Y = " with extra!", string_concat(X, Y, Z).
X = "a test string",
Y = " with extra!",
Z = "a test string with extra!".
