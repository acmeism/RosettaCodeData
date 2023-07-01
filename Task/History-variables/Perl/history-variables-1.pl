package History;

sub TIESCALAR {
	my $cls = shift;
	my $cur_val = shift;
	return bless [];
}

sub FETCH {
	return shift->[-1]
}

sub STORE {
	my ($var, $val) = @_;
	push @$var, $val;
	return $val;
}

sub get(\$) { @{tied ${+shift}} }
sub on(\$) { tie ${+shift}, __PACKAGE__ }
sub off(\$) { untie ${+shift} }
sub undo(\$) { pop @{tied ${+shift}} }

package main;

my $x = 0;
History::on($x);

for ("a" .. "d") { $x = $_ }

print "History: @{[History::get($x)]}\n";

for (1 .. 3) {
	print "undo $_, ";
	History::undo($x);
	print "current value: $x\n";
}

History::off($x);
print "\$x is: $x\n";
