print qq:to 'END'
positive infinity: {1.8e308}
negative infinity: {-1.8e308}
negative zero: {0e0 * -1}
not a number: {0 * 1e309}
+Inf + 2.0 = {Inf + 2}
+Inf - 10.1 = {Inf - 10.1}
0 * +Inf = {0 * Inf}
+Inf + -Inf = {Inf + -Inf}
+Inf == -Inf = {+Inf == -Inf}
(-Inf+0i)**.5 = {(-Inf+0i)**.5}
NaN + 1.0 = {NaN + 1.0}
NaN + NaN = {NaN + NaN}
NaN == NaN = {NaN == NaN}
0.0 == -0.0 = {0e0 == -0e0}
END
