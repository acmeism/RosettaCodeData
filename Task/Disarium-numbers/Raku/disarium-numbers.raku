my $disarium = (^∞).hyper.map: { $_ if $_ == sum .polymod(10 xx *).reverse Z** 1..* };

put $disarium[^18];
put $disarium[18];
