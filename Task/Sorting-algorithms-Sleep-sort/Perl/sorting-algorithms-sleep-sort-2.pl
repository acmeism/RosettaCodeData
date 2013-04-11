use Coro;
$ret = Coro::Channel->new;
@nums = qw(1 32 2 59 2 39 43 15 8 9 12 9 11);

for my $n (@nums){
	async {
		Coro::cede for 1..$n;
		$ret->put($n);
	}
}

print $ret->get,"\n" for 1..@nums;
