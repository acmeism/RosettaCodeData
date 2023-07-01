my @S = {1 + [*] @S[^($++)]} … *;

put 'First 10 elements of Sylvester\'s sequence: ', @S[^10];

say "\nSum of the reciprocals of first 10 elements: ", sum @S[^10].map: { FatRat.new: 1, $_ };
