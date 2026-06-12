my @coprime-triplets = 1, 2, {
   state %seen = 1, True, 2, True;
   state $min = 3;
   my $g = $^a * $^b;
   my $n = ($min .. *).first: { !%seen{$_} && ($_ gcd $g == 1) }
   %seen{$n} = True;
   if %seen.elems %% 100 { $min = ($min .. *).first: { !%seen{$_} } }
   $n
} … *;

put "Coprime triplets before first > 50:\n",
@coprime-triplets[^(@coprime-triplets.first: * > 50, :k)].batch(10)».fmt("%4d").join: "\n";

put "\nOr maybe, minimum Coprime triplets that encompass 1 through 50:\n",
@coprime-triplets[0..(@coprime-triplets.first: * == 42, :k)].batch(10)».fmt("%4d").join: "\n";

put "\nAnd for the heck of it: 1001st through 1050th Coprime triplet:\n",
@coprime-triplets[1000..1049].batch(10)».fmt("%4d").join: "\n";
