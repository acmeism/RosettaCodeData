my @pi = (1..*).map: { state $pi = 0; $pi += .is-prime };

say @pi[^(@pi.first: * >= 22, :k)].batch(10)».fmt('%2d').join: "\n";
