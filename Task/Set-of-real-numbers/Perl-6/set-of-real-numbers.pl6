class Iv {
    has $.range handles <min max excludes-min excludes-max minmax ACCEPTS>;
    method empty {
	$.min after $.max or $.min === $.max && ($.excludes-min || $.excludes-max)
    }
    multi method Bool() { not self.empty };
    method length() { $.max - $.min }
    method gist() {
	($.excludes-min ?? '(' !! '[') ~
	$.min ~ ',' ~ $.max ~
	($.excludes-max ?? ')' !! ']');
    }
}

class IvSet {
    has Iv @.intervals;

    sub canon (@i) {
	my @new = consolidate(|@i).grep(*.so);
	@new.sort(*.range.min);
    }

    method new(@ranges) {
	my @iv = canon @ranges.map: { Iv.new(:range($_)) }
	self.bless(:intervals(@iv));
    }

    method complement {
	my @new;
	my @old = @!intervals;
	if not @old {
	    return iv -Inf..Inf;
	}
	my $pre;
	push @old, $(Inf^..Inf) unless @old[*-1].max === Inf;
	if @old[0].min === -Inf {
	    $pre = @old.shift;
	}
	else {
	    $pre = -Inf..^-Inf;
	}
	while @old {
	    my $old = @old.shift;
	    my $excludes-min = !$pre.excludes-max;
	    my $excludes-max = !$old.excludes-min;
	    push @new, $(Range.new($pre.max,$old.min,:$excludes-min,:$excludes-max));
	    $pre = $old;
	}
	IvSet.new(@new);
    }

    method ACCEPTS(IvSet:D $me: $candidate) {
	so $.intervals.any.ACCEPTS($candidate);
    }
    method empty { so $.intervals.all.empty }
    multi method Bool() { not self.empty };

    method length() { [+] $.intervals».length }
    method gist() { join ' ', $.intervals».gist }
}

sub iv(**@ranges) { IvSet.new(@ranges) }

multi infix:<∩> (Iv $a, Iv $b) {
    if $a.min ~~ $b or $a.max ~~ $b or $b.min ~~ $a or $b.max ~~ $a {
	my $min = $a.range.min max $b.range.min;
	my $max = $a.range.max min $b.range.max;
	my $excludes-min = not $min ~~ $a & $b;
	my $excludes-max = not $max ~~ $a & $b;
	Iv.new(:range(Range.new($min,$max,:$excludes-min, :$excludes-max)));
    }
}
multi infix:<∪> (Iv $a, Iv $b) {
    my $min = $a.range.min min $b.range.min;
    my $max = $a.range.max max $b.range.max;
    my $excludes-min = not $min ~~ $a | $b;
    my $excludes-max = not $max ~~ $a | $b;
    Iv.new(:range(Range.new($min,$max,:$excludes-min, :$excludes-max)));
}

multi infix:<∩> (IvSet $ars, IvSet $brs) {
    my @overlap;
    for $ars.intervals -> $a {
	for $brs.intervals -> $b {
	    if $a.min ~~ $b or $a.max ~~ $b or $b.min ~~ $a or $b.max ~~ $a {
		my $min = $a.range.min max $b.range.min;
		my $max = $a.range.max min $b.range.max;
		my $excludes-min = not $min ~~ $a & $b;
		my $excludes-max = not $max ~~ $a & $b;
		push @overlap, $(Range.new($min,$max,:$excludes-min, :$excludes-max));
	    }
	}
    }
    IvSet.new(@overlap)
}

multi infix:<∪> (IvSet $a, IvSet $b) {
    iv |$a.intervals».range, |$b.intervals».range;
}

multi consolidate() { () }
multi consolidate($this is copy, *@those) {
    gather {
        for consolidate |@those -> $that {
            if $this ∩ $that { $this ∪= $that }
            else             { take $that }
        }
        take $this;
    }
}

multi infix:<−> (IvSet $a, IvSet $b) { $a ∩ $b.complement }

multi prefix:<−> (IvSet $a) { $a.complement; }

constant ℝ = iv -Inf..Inf;

my $s1 = iv(0^..1) ∪ iv(0..^2);
my $s2 = iv(0..^2) ∩ iv(1^..2);
my $s3 = iv(0..^3) − iv(0^..^1);
my $s4 = iv(0..^3) − iv(0..1) ;

say "\t\t\t\t0\t1\t2";
say "(0, 1] ∪ [0, 2) -> $s1.gist()\t", 0 ~~ $s1,"\t", 1 ~~ $s1,"\t", 2 ~~ $s1;
say "[0, 2) ∩ (1, 2] -> $s2.gist()\t", 0 ~~ $s2,"\t", 1 ~~ $s2,"\t", 2 ~~ $s2;
say "[0, 3) − (0, 1) -> $s3.gist()\t", 0 ~~ $s3,"\t", 1 ~~ $s3,"\t", 2 ~~ $s3;
say "[0, 3) − [0, 1] -> $s4.gist()\t", 0 ~~ $s4,"\t", 1 ~~ $s4,"\t", 2 ~~ $s4;

say '';

say "ℝ is not empty: ", !ℝ.empty;
say "[0,3] − ℝ is empty: ", not iv(0..3) − ℝ;

my $A = iv(0..10) ∩
   iv |(0..10).map({ $_ - 1/6 .. $_ + 1/6 }).cache;

my $B = iv 0..sqrt(1/6),
	   |(1..99).map({ $(sqrt($_-1/6) .. sqrt($_ + 1/6)) }),
	   sqrt(100-1/6)..10;

say 'A − A is empty: ', not $A − $A;

say '';

my $C = $A − $B;
say "A − B =";
say "  ",.gist for $C.intervals;
say "Length A − B = ", $C.length;
