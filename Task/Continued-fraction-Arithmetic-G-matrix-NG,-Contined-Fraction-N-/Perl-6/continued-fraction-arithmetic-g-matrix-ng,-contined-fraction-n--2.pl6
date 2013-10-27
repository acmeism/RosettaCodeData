my @continued-fraction = NG.new( 1,1,0,2 ).apply( ( 1, 2 xx * ), limit => 100 );
say @continued-fraction.&ppcf.comb(/ . ** 1..80/).join("\n");
say @continued-fraction.&cf2r.&pprat;
