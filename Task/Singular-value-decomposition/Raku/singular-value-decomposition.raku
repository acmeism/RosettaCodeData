# 20230108 Raku programming solution

use Math::Libgsl::Matrix;
use Math::Libgsl::LinearAlgebra;

my @M = <3 0>, <4 5>;
my Math::Libgsl::Matrix \M .= new: @M.elems, @M.first.elems;
(^M.size1)>>.&{ M.set-row: $_, @M[$_;*] }

my (\V,\S) = SV-decomp M;

say "U factor: "        and say (^M.size1)>>.&{ M.get-row($_)>>.fmt: '%.10g' }
say "singular values: " and say (^S.size )>>.&{     S.get($_)>>.fmt: '%.10g' }
say "Vt factor: "       and say (^V.size1)>>.&{ V.get-row($_)>>.fmt: '%.10g' }
