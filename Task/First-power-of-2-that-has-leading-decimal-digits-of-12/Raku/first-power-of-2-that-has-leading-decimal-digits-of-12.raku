use Lingua::EN::Numbers;

constant $ln2ln10 = log(2) / log(10);

my @startswith12  = ^∞ .grep: { ( 10 ** ($_ * $ln2ln10 % 1) ).substr(0,3) eq '1.2' };

my @startswith123 = lazy gather loop {
    state $pre   = '1.23';
    state $count = 0;
    state $this  = 0;
    given $this {
        when 196 {
            $this = 289;
            my \n = $count + $this;
            $this = 485 unless ( 10 ** (n * $ln2ln10 % 1) ).substr(0,4) eq $pre;
        }
        when 485 {
            $this = 196;
            my \n = $count + $this;
            $this = 485 unless ( 10 ** (n * $ln2ln10 % 1) ).substr(0,4) eq $pre;
        }
        when 289 { $this = 196 }
        when 90  { $this = 289 }
        when 0   { $this = 90  }
    }
    take $count += $this;
}

multi p ($prefix where *.chars == 2, $nth) {  @startswith12[$nth-1] }
multi p ($prefix where *.chars == 3, $nth) { @startswith123[$nth-1] }

# The Task
for < 12 1  12 2  123 45  123 12345  123 678910 > -> $prefix, $nth {
    printf "%-15s %9s power of two (2^n) that starts with %5s is at n = %s\n", "p($prefix, $nth):",
        comma($nth) ~ ordinal-digit($nth).substr(*-2), "'$prefix'", comma p($prefix, $nth);
}
