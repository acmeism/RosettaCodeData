palindrome(Word) :- name(Word,List), reverse(List,List).

:- begin_tests(palindrome).

test(valid_palindrome) :- palindrome('ingirumimusnocteetconsumimurigni').
test(invalid_palindrome, [fail]) :- palindrome('this is not a palindrome').

:- end_tests(palindrome).
