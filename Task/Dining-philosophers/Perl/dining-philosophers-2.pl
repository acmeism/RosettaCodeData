#!/usr/bin/perl
use common::sense;
use Coro;
use AnyEvent;
use Coro::AnyEvent;
use EV;

my @philosophers = qw(Aristotle Kant Spinoza Marx Russell);
my @forks = (1..@philosophers);
my @fork_sem;

$fork_sem[$_] = new Coro::Semaphore for (0..$#philosophers);


for(my $i = $#philosophers; $i >= 0; $i--){
	say $philosophers[$i] . " has fork #" . $forks[$i] . " and fork #" . $forks[$i-1];
	async {
		my ($name, ,$no, $forks_got) = (@_);

		$Coro::current->{desc} = $name;
		Coro::AnyEvent::sleep(rand 4);

		while(1){
			say $name . " is hungry.";
			$$forks_got[$no]->down();
			Coro::AnyEvent::sleep(rand 1); #Let's make deadlock!
			$$forks_got[$no-1]->down();
			say $name . " is eating.";
			Coro::AnyEvent::sleep(1 + rand 8);

			$$forks_got[$no]->up();
			$$forks_got[$no-1]->up();
			
			say $name . " is thinking.";
			Coro::AnyEvent::sleep(1 + rand 8);
		}
	}($philosophers[$i], $i, \@fork_sem);
}

EV::loop;
