role Egyptian {
    method gist { join ' + ', map {"1/$_"}, self.list }
    method list {
	my $sum = 0;
	gather for 2 .. * {
	    last if $sum == self;
	    $sum += 1 / .take unless $sum + 1 / $_ > self;
	}
    }
}

say 5/4 but Egyptian;
