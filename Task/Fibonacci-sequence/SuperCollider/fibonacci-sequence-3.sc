(
	f = { |n|
		var sqrt5 = sqrt(5);
		var p = (1 + sqrt5) / 2;
		var q = reciprocal(p);
		((p ** n) + (q ** n) / sqrt5 + 0.5).trunc
	};
	(0..20).collect(f)
)
