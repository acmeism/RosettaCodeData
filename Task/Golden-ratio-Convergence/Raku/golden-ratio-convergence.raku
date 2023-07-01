constant phi = 1.FatRat, 1 + 1/* ... { abs($^a-$^b)≤1e-5 };

say "It took {phi.elems} iterations to reach {phi.tail}";
say "The error is {{ ($^a - $^b)/$^b }(phi.tail, (1+sqrt(5))/2)}"
