(
d = { |array, n|
	Routine {
		n = n ?? { array.size.factorial };
		n.do { |i|
			var permuted = array.permute(i);
			if(array.every { |each, i| permuted[i] != each }) {
				permuted.yield
			};
		}
	};
};
f = { |n| d.((0..n-1)) };
x = f.(4);
x.all.do(_.postln); "";
)
