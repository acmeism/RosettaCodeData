use Test;
my @testcases =
		() => (),
		<a>.List => <a>.List,
		<a a> => <a a>,
		<a b> => <a b>,
		<b a> => <a b>,
		<h b a c d f e g> => <a b c d e f g h>,
		(2, 3, 1, 4, 5) => (1, 2, 3, 4, 5),
		<a 🎮 3 z 4 🐧> => <a 🎮 3 z 4 🐧>.sort
;
my @implementations = &quicksort, &seven-line-quicksort-parallel, &quicksort-parallel;
plan @testcases.elems * @implementations.elems;
for @implementations ->  &fun {
	say &fun.name;
	is-deeply &fun(.key), .value, .key ~ "  =>  " ~ .value for @testcases;
}
done-testing;
