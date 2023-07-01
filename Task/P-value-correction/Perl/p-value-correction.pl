#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';
use autodie ':all';
use List::Util 'min';
use feature 'say';

sub pmin {
	my $array = shift;
	my $x = 1;
	my @pmin_array;
	my $n = scalar @$array;
	for (my $index = 0; $index < $n; $index++) {
		$pmin_array[$index] = min(@$array[$index], $x);
	}
	@pmin_array
}

sub cummin {
	my $array_ref = shift;
	my @cummin;
	my $cumulative_min = @$array_ref[0];
	foreach my $p (@$array_ref) {
		if ($p < $cumulative_min) {
			$cumulative_min = $p;
		}
		push @cummin, $cumulative_min;
	}
	@cummin
}

sub cummax {
	my $array_ref = shift;
	my @cummax;
	my $cumulative_max = @$array_ref[0];
	foreach my $p (@$array_ref) {
		if ($p > $cumulative_max) {
			$cumulative_max = $p;
		}
		push @cummax, $cumulative_max;
	}
	@cummax
}

sub order {#made to match R's "order"
	my $array_ref = shift;
	my $decreasing = 'false';
	if (defined $_[0]) {
		my $option = shift;
		if ($option =~ m/true/i) {
			$decreasing = 'true';
		} elsif ($option =~ m/false/i) {
			#do nothing, it's already set to false
		} else {
			print "2nd option should only be case-insensitive 'true' or 'false'";
			die;
		}
	}
	my @array;
	my $max_index = scalar @$array_ref-1;
	if ($decreasing eq 'false') {
		@array = sort { @$array_ref[$a] <=> @$array_ref[$b] } 0..$max_index;
	} elsif ($decreasing eq 'true') {
		@array = sort { @$array_ref[$b] <=> @$array_ref[$a] } 0..$max_index;
	}
	@array
}


sub p_adjust {
	my $pvalues_ref = shift;
	my $method;
	if (defined $_[0]) {
		$method = shift
	} else {
		$method = 'Holm'
	}
	my %methods = (
						'bh'         => 1,
						'fdr'        => 1,
						'by'         => 1,
						'holm'       => 1,
						'hommel'     => 1,
						'bonferroni' => 1,
						'hochberg'   => 1
						);
	my $method_found = 'no';
	foreach my $key (keys %methods) {
		if ((uc $method) eq (uc $key)) {
			$method = $key;
			$method_found = 'yes';
			last
		}
	}
	if ($method_found eq 'no') {
		if ($method =~ m/benjamini-?\s*hochberg/i) {
			$method = 'bh';
			$method_found = 'yes';
		} elsif ($method =~ m/benjamini-?\s*yekutieli/i) {
			$method = 'by';
			$method_found = 'yes';
		}
	}
	if ($method_found eq 'no') {
		print "No method could be determined from $method.\n";
		die
	}
	my $lp = scalar @$pvalues_ref;
	my $n  = $lp;
	my @qvalues;
	if ($method eq 'hochberg') {
		my @o = order($pvalues_ref, 'TRUE');
		my @cummin_input;
		for (my $index = 0; $index < $n; $index++) {
			$cummin_input[$index] = ($index+1)* @$pvalues_ref[$o[$index]];#PVALUES[$o[$index]] is p[o]
		}
		my @cummin = cummin(\@cummin_input);
		my @pmin   = pmin(\@cummin);
		my @ro = order(\@o);
		@qvalues = @pmin[@ro];
	} elsif ($method eq 'bh') {
		my @o = order($pvalues_ref, 'TRUE');
		my @cummin_input;
		for (my $index = 0; $index < $n; $index++) {
			$cummin_input[$index] = ($n/($n-$index))* @$pvalues_ref[$o[$index]];#PVALUES[$o[$index]] is p[o]
		}
		my @ro = order(\@o);
		my @cummin = cummin(\@cummin_input);
		my @pmin   = pmin(\@cummin);
		@qvalues = @pmin[@ro];
	} elsif ($method eq 'by') {
		my $q = 0.0;
		my @o = order($pvalues_ref, 'TRUE');
		my @ro = order(\@o);
		for (my $index = 1; $index < ($n+1); $index++) {
			$q += 1.0 / $index;
		}
		my @cummin_input;
		for (my $index = 0; $index < $n; $index++) {
			$cummin_input[$index] = $q * ($n/($n-$index)) * @$pvalues_ref[$o[$index]];#PVALUES[$o[$index]] is p[o]
		}
#		say join (',', @cummin_input);
#		say '@cummin_input # of elements = ' . scalar @cummin_input;
		my @cummin = cummin(\@cummin_input);
		undef @cummin_input;
		my @pmin   = pmin(\@cummin);
		@qvalues = @pmin[@ro];
	} elsif ($method eq 'bonferroni') {
		for (my $index = 0; $index < $n; $index++) {
			my $q = @$pvalues_ref[$index]*$n;
			if ((0 <= $q) && ($q < 1)) {
				$qvalues[$index] = $q;
			} elsif ($q >= 1) {
				$qvalues[$index] = 1.0;
			} else {
				say 'Failed to get Bonferroni adjusted p.';
				die;
			}
		}
	} elsif ($method eq 'holm') {
		my @o = order($pvalues_ref);
		my @cummax_input;
		for (my $index = 0; $index < $n; $index++) {
			$cummax_input[$index] = ($n - $index) * @$pvalues_ref[$o[$index]];
		}
		my @ro = order(\@o);
		undef @o;
		my @cummax = cummax(\@cummax_input);
		undef @cummax_input;
		my @pmin = pmin(\@cummax);
		undef @cummax;
		@qvalues = @pmin[@ro];
	} elsif ($method eq 'hommel') {
		my @o = order($pvalues_ref);
		my @p = @$pvalues_ref[@o];
		my @ro = order(\@o);
		undef @o;
		my (@q, @pa);
		my $min = $n*$p[0];
		for (my $index = 0; $index < $n; $index++) {
			my $temp = $n*$p[$index] / ($index + 1);
			$min = min($min, $temp);
		}
		for (my $index = 0; $index < $n; $index++) {
			$pa[$index] = $min;#q <- pa <- rep.int(min(n * p/i), n)
			 $q[$index] = $min;#q <- pa <- rep.int(min(n * p/i), n)
		}
		for (my $j = ($n-1); $j >= 2; $j--) {
			my @ij = 0..($n - $j);#ij <- seq_len(n - j + 1)
			my $I2_LENGTH = $j - 1;
			my @i2;
			for (my $i = 0; $i < $I2_LENGTH; $i++) {
				$i2[$i] = $n-$j+2+$i-1;
#R's indices are 1-based, C's are 0-based, I added the -1
			}

			my $q1 = $j * $p[$i2[0]] / 2.0;
			for (my $i = 1; $i < $I2_LENGTH; $i++) {#loop through 2:j
				my $TEMP_Q1 = $j * $p[$i2[$i]] / (2 + $i);
				$q1 = min($TEMP_Q1, $q1);
			}
			for (my $i = 0; $i < ($n - $j + 1); $i++) {#q[ij] <- pmin(j * p[ij], q1)
				$q[$ij[$i]] = min( $j*$p[$ij[$i]], $q1);
			}

			for (my $i = 0; $i < $I2_LENGTH; $i++) {#q[i2] <- q[n - j + 1]
				$q[$i2[$i]] = $q[$n - $j];
			}

			for (my $i = 0; $i < $n; $i++) {#pa <- pmax(pa, q)
				if ($pa[$i] < $q[$i]) {
					$pa[$i] = $q[$i];
				}
			}
#			printf("j = %zu, pa = \n", j);
#				double_say(pa, N);
		}#end j loop
		@qvalues = @pa[@ro];
	} else {
		print "$method doesn't fit my types.\n";
		die
	}
	@qvalues
}
my @pvalues = (4.533744e-01, 7.296024e-01, 9.936026e-02, 9.079658e-02, 1.801962e-01,
8.752257e-01, 2.922222e-01, 9.115421e-01, 4.355806e-01, 5.324867e-01,
4.926798e-01, 5.802978e-01, 3.485442e-01, 7.883130e-01, 2.729308e-01,
8.502518e-01, 4.268138e-01, 6.442008e-01, 3.030266e-01, 5.001555e-02,
3.194810e-01, 7.892933e-01, 9.991834e-01, 1.745691e-01, 9.037516e-01,
1.198578e-01, 3.966083e-01, 1.403837e-02, 7.328671e-01, 6.793476e-02,
4.040730e-03, 3.033349e-04, 1.125147e-02, 2.375072e-02, 5.818542e-04,
3.075482e-04, 8.251272e-03, 1.356534e-03, 1.360696e-02, 3.764588e-04,
1.801145e-05, 2.504456e-07, 3.310253e-02, 9.427839e-03, 8.791153e-04,
2.177831e-04, 9.693054e-04, 6.610250e-05, 2.900813e-02, 5.735490e-03);

my %correct_answers = (
	'Benjamini-Hochberg' => [6.126681e-01, 8.521710e-01, 1.987205e-01, 1.891595e-01, 3.217789e-01,
9.301450e-01, 4.870370e-01, 9.301450e-01, 6.049731e-01, 6.826753e-01,
6.482629e-01, 7.253722e-01, 5.280973e-01, 8.769926e-01, 4.705703e-01,
9.241867e-01, 6.049731e-01, 7.856107e-01, 4.887526e-01, 1.136717e-01,
4.991891e-01, 8.769926e-01, 9.991834e-01, 3.217789e-01, 9.301450e-01,
2.304958e-01, 5.832475e-01, 3.899547e-02, 8.521710e-01, 1.476843e-01,
1.683638e-02, 2.562902e-03, 3.516084e-02, 6.250189e-02, 3.636589e-03,
2.562902e-03, 2.946883e-02, 6.166064e-03, 3.899547e-02, 2.688991e-03,
4.502862e-04, 1.252228e-05, 7.881555e-02, 3.142613e-02, 4.846527e-03,
2.562902e-03, 4.846527e-03, 1.101708e-03, 7.252032e-02, 2.205958e-02],
	'Benjamini-Yekutieli' => [1.000000e+00, 1.000000e+00, 8.940844e-01, 8.510676e-01, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 5.114323e-01,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.754486e-01, 1.000000e+00, 6.644618e-01,
7.575031e-02, 1.153102e-02, 1.581959e-01, 2.812089e-01, 1.636176e-02,
1.153102e-02, 1.325863e-01, 2.774239e-02, 1.754486e-01, 1.209832e-02,
2.025930e-03, 5.634031e-05, 3.546073e-01, 1.413926e-01, 2.180552e-02,
1.153102e-02, 2.180552e-02, 4.956812e-03, 3.262838e-01, 9.925057e-02],
	'Bonferroni' => [1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 7.019185e-01, 1.000000e+00, 1.000000e+00,
2.020365e-01, 1.516674e-02, 5.625735e-01, 1.000000e+00, 2.909271e-02,
1.537741e-02, 4.125636e-01, 6.782670e-02, 6.803480e-01, 1.882294e-02,
9.005725e-04, 1.252228e-05, 1.000000e+00, 4.713920e-01, 4.395577e-02,
1.088915e-02, 4.846527e-02, 3.305125e-03, 1.000000e+00, 2.867745e-01],

	'Hochberg' => [9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
9.991834e-01, 9.991834e-01, 4.632662e-01, 9.991834e-01, 9.991834e-01,
1.575885e-01, 1.383967e-02, 3.938014e-01, 7.600230e-01, 2.501973e-02,
1.383967e-02, 3.052971e-01, 5.426136e-02, 4.626366e-01, 1.656419e-02,
8.825610e-04, 1.252228e-05, 9.930759e-01, 3.394022e-01, 3.692284e-02,
1.023581e-02, 3.974152e-02, 3.172920e-03, 8.992520e-01, 2.179486e-01],
	'Holm' => [1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
1.000000e+00, 1.000000e+00, 4.632662e-01, 1.000000e+00, 1.000000e+00,
1.575885e-01, 1.395341e-02, 3.938014e-01, 7.600230e-01, 2.501973e-02,
1.395341e-02, 3.052971e-01, 5.426136e-02, 4.626366e-01, 1.656419e-02,
8.825610e-04, 1.252228e-05, 9.930759e-01, 3.394022e-01, 3.692284e-02,
1.023581e-02, 3.974152e-02, 3.172920e-03, 8.992520e-01, 2.179486e-01],

	'Hommel' => [9.991834e-01, 9.991834e-01, 9.991834e-01, 9.987624e-01, 9.991834e-01,
9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.595180e-01,
9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
9.991834e-01, 9.991834e-01, 4.351895e-01, 9.991834e-01, 9.766522e-01,
1.414256e-01, 1.304340e-02, 3.530937e-01, 6.887709e-01, 2.385602e-02,
1.322457e-02, 2.722920e-01, 5.426136e-02, 4.218158e-01, 1.581127e-02,
8.825610e-04, 1.252228e-05, 8.743649e-01, 3.016908e-01, 3.516461e-02,
9.582456e-03, 3.877222e-02, 3.172920e-03, 8.122276e-01, 1.950067e-01]);


foreach my $method ('Hochberg','Benjamini-Hochberg','Benjamini-Yekutieli', 'Bonferroni', 'Holm', 'Hommel') {
	print "$method\n";
	my @qvalues = p_adjust(\@pvalues, $method);
	my $error = 0.0;
	foreach my $q (0..$#qvalues) {
		$error += abs($qvalues[$q] - $correct_answers{$method}[$q]);
	}
	printf("type $method has cumulative error of %g.\n", $error);
}
