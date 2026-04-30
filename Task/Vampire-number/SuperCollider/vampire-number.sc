(
// Usage: ~extract_fangs.(n), where n is a positive integer
//
// Return a list made of all the fangs of n. If n isn't a vampire,
// then an empty list is returned.
// n can be a floating point number as long as its fractional part
// is equal to 0.
~extract_fangs = {
	arg n; var out = List[], f, is_fang, f1, f2, i = 0,
	nd = [], nr, n_cp = n, k;

	// Convert n to an array made of its digits
	//  > fast method used when n is a 32-bit int or float
	nr = n_cp % 1e9;
	nd = nr.asInteger.asDigits ++ nd;
	n_cp = n_cp - nr;

	//  > slower method used when n is a 64-bit float
	if(n_cp > 0){
		n_cp = n; nd = [];
		while{n_cp - (10**(i + 1)) > 0}{i = i + 1};
		for(0, i){
			arg j; k = i - j;
			nr = floor(n_cp / (10**k));
			nd = nd ++ [nr];
			n_cp = n_cp - (nr * (10**k));
		};
	};

	// Even number of digits
	if(nd.size % 2 == 1){}{

		for(1, floor(sqrt(n))){
			arg i; is_fang = true; f = [];
			if(n % i == 0){
				f = [i, n/i];
			}{is_fang = false};

			if(is_fang){
				f1 = f[0].asInteger.asDigits;
				f2 = f[1].asInteger.asDigits;

				// Each fang has the same number of digits
				if((f1.size != (nd.size/2)) ||
					(f2.size != (nd.size/2))){is_fang = false}{

					// At most one has a trailing zero
					if((f1[f1.size - 1] == 0) &&
						(f2[f2.size - 1] == 0)){is_fang = false}{

						if((f1 ++ f2).sort != nd.sort)
						{is_fang = false}{};
					};

				};

				if(is_fang){out.add(f)}{};
			}{};
		};
	};
	out
};


~goal = 25; ~i = 0; ~f;
"25 first vampire numbers
-------------------------------".postln;
while{~goal > 0}{
	if((~f = ~extract_fangs.(~i = ~i + 1)) == List[]){}{
		~goal = ~goal - 1;
		("n°" ++ (25 - ~goal).asString ++ " is " ++
			~i.asString ++ "; fangs: ").post;
		~f.postln;
	};
};

"\nIndividual tests
-------------------------------".postln;
[16758243290880.0,  24959017348650.0,  14593825548650.0].do{
	arg n; n.asString.post;
	if((~f = ~extract_fangs.(n)) == List[])
	{" isn't a vampire number.".postln;}
	{" is a vampire number; fangs: ".post; ~f.postln;};
};
)
