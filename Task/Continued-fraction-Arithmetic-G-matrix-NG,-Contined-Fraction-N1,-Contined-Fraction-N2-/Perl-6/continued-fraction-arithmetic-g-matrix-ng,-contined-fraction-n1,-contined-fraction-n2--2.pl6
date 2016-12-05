say "√2 expressed as a continued fraction: ";
my @root2 = lazy flat 1, 2 xx *;
my @result = NG2.new.operator(|%ops{'*'}).apply( @root2, @root2, limit => 6 );
say @root2.&ppcf, "² = \n";
say @result.&ppcf;
say "\nConverted back to an arbitrary (ludicrous) precision Rational: ";
say @result.&cf2r.nude.join(" /\n");
say "\nCoerced to a standard precision Rational: ", @result.&cf2r.Num.Rat;
