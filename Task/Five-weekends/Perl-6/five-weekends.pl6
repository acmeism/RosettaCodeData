# A month has 5 weekends iff it has 31 days and starts on Friday.

my @years = 1900 .. 2100;
my @has31 = 1, 3, 5, 7, 8, 10, 12;
my @happy = ($_ when *.day-of-week == 5 for (@years X @has31).map(-> ($y, $m) { Date.new: $y, $m, 1 }));

say 'Happy month count:  ', +@happy;
say 'First happy months: ' ~ @happy[^5];
say 'Last  happy months: ' ~ @happy[*-5 .. *];
say 'Dreary years count: ',  @years - @happy».year.squish;
