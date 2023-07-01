:- op(200, xfx, user:(=+)).

%% +Prepend =+ +Chars
%
%    Will destructively update Chars
%    So that Chars = Prepend prefixed to Chars.
%    eazar001 in ##prolog helped refine this approach.

[X|Xs] =+ Chars :-
  append(Xs, Chars, Rest),
  nb_setarg(2, Chars, Rest),
  nb_setarg(1, Chars, X).
