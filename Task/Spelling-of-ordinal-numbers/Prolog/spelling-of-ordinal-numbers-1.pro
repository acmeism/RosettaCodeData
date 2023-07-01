test_ordinal(Number):-
    number_name(Number, ordinal, Name),
    writef('%w: %w\n', [Number, Name]).

main:-
    test_ordinal(1),
    test_ordinal(2),
    test_ordinal(3),
    test_ordinal(4),
    test_ordinal(5),
    test_ordinal(11),
    test_ordinal(15),
    test_ordinal(21),
    test_ordinal(42),
    test_ordinal(65),
    test_ordinal(98),
    test_ordinal(100),
    test_ordinal(101),
    test_ordinal(272),
    test_ordinal(300),
    test_ordinal(750),
    test_ordinal(23456),
    test_ordinal(7891233),
    test_ordinal(8007006005004003).
