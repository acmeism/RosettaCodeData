1> (fn:compose(fun math:sin/1, fun math:asin/1))(0.5).
0.5
2> Sin_asin_plus1 = fn:multicompose([fun math:sin/1, fun math:asin/1, fun(X) -> X + 1 end]).
#Fun<tests.0.59446746>
82> Sin_asin_plus1(0.5).
1.5
