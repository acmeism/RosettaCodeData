use ntheory qw/hammingweight/;
say hammingweight(1234567);

use Math::GMPz qw/Rmpz_popcount/;
say Rmpz_popcount(Math::GMPz->new(1234567));

use Math::BigInt;
say 0 + (Math::BigInt->new(1234567)->as_bin() =~ tr/1//);

use Bit::Vector;
say Bit::Vector->new_Dec(64,1234567)->Norm;
