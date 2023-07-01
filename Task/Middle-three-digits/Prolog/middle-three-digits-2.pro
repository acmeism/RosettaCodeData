test_correct :-
    TestCases = [123, 12345, 1234567, 987654321, 10001, -10001, -123, -100, 100, -12345],
    foreach( ( member(TestCase, TestCases),
               middle_3_digits(TestCase, Result) ),
            format('Middle 3 digits of ~w ~30|: ~w~n', [TestCase, Result])
          ).
