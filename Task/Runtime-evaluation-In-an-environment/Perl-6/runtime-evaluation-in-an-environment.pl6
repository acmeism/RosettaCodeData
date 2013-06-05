sub eval_with_x($code, *@x) { [R-] @x.map: -> \x { eval $code } }

say eval_with_x('3 * x', 5, 10);      # Says "15".
say eval_with_x('3 * x', 5, 10, 50);  # Says "135".
