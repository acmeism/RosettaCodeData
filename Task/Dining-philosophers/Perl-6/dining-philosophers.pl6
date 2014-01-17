class Fork {
    has $!lock = Lock.new;
    method grab($who, $which) {
	remark "$who grabbing $which fork";
	$!lock.lock;
    }
    method drop($who, $which) {
	remark "$who dropping $which fork";
	$!lock.unlock;
    }
}

class Lollipop {
    has $!channel = Channel.new;
    method mine($who) { $!channel.send($who) }
    method yours { $!channel.receive }
}

my $out = Channel.new;
sub remark($msg) { $out.send($msg) }
start { loop { $out.receive.say } }

sub dally($sec) { sleep 0.01 + rand * $sec }

sub MAIN(*@names) {
    @names ||= <Aristotle Kant Spinoza Marx Russell>;

    my @lfork = Fork.new xx @names;
    my @rfork = @lfork.rotate;

    my $lollipop = Lollipop.new;
    start { $lollipop.yours; }

    my @philosophers = do for @names Z @lfork Z @rfork -> $n, $l, $r {
	start {
	    sleep 1 + rand*4;
	    loop {
		$l.grab($n,'left');
		dally 1;  # give opportunity for deadlock
		$r.grab($n,'right');
		remark "$n eating";
		dally 10;
		$l.drop($n,'left');
		$r.drop($n,'right');

		$lollipop.mine($n);
		sleep 1;  # lick at least once
		remark "$n lost lollipop to $lollipop.yours(), now digesting";

		dally 20;
	    }
	}
    }
    await @philosophers;
}
