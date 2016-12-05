(
f = { |x|
	var res = res ?? List.new;
	if(x.isSequenceableCollection) {
		x.do { |each|
			res.addAll(f.(each))
		}
	} {
		res.add(x);
	};
	res
};
f.([[1], 2, [[3, 4], 5], [[[]]], [[[6]]], 7, 8, []]);
)
