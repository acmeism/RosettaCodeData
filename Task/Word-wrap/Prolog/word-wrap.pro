% See https://en.wikipedia.org/wiki/Line_wrap_and_word_wrap#Minimum_number_of_lines
word_wrap(String, Length, Wrapped):-
    re_split("\\S+", String, Words),
    wrap(Words, Length, Length, Wrapped, '').

wrap([_], _, _, Result, Result):-!.
wrap([Space, Word|Words], Line_length, Space_left, Result, String):-
    string_length(Word, Word_len),
    string_length(Space, Space_len),
    (Space_left < Word_len + Space_len ->
        Space1 = '\n',
        Space_left1 is Line_length - Word_len
        ;
        Space1 = Space,
        Space_left1 is Space_left - Word_len - Space_len
    ),
    atomic_list_concat([String, Space1, Word], String1),
    wrap(Words, Line_length, Space_left1, Result, String1).

sample_text("Lorem ipsum dolor sit amet, consectetur adipiscing \
elit, sed do eiusmod tempor incididunt ut labore et dolore magna \
aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco \
laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure \
dolor in reprehenderit in voluptate velit esse cillum dolore eu \
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non \
proident, sunt in culpa qui officia deserunt mollit anim id est \
laborum.").

test_word_wrap(Line_length):-
    sample_text(Text),
    word_wrap(Text, Line_length, Wrapped),
    writef('Wrapped at %w characters:\n%w\n',
           [Line_length, Wrapped]).

main:-
    test_word_wrap(60),
    nl,
    test_word_wrap(80).
