% And make some comparisons:
() = printf("-0.0 and 0.0 are %sequal\n", -0.0 == 0.0 ? "" : "not ");
() = printf("-_Inf == _Inf are %sequal\n", -_Inf == _Inf ? "" : "not ");
() = printf("-0.0 and 0.0 are %sthe 'same'\n", __is_same(-0.0, 0.0) ? "" : "not ");
