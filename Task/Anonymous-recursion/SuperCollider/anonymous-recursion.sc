(
f = { |n|
	if(n >= 0) {
		if(n < 2) { n } { thisFunction.(n-1) + thisFunction.(n-2) }
	}
};
(0..20).collect(f)
)
