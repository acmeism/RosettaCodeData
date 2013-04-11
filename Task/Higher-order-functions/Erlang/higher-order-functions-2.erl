1> c(tests).
{ok, tests}
2> tests:first(fun tests:second/0).
hello
3> tests:first(fun() -> anonymous_function end).
anonymous_function
