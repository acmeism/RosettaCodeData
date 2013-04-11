# A month has 5 weekends iff it has 31 days and starts on Friday.

my @years = 1900 .. 2100;
my @ym = @years X 1, 3, 5, 7, 8, 10, 12; # Months with 31 days

my @happy = @ym.map({ Date.new: $^a, $^b, 1 }).grep: { .day-of-week == 5 };

say 'Happy month count:  ',  +@happy;
say 'First happy months: ' ~ @happy[^5];
say 'Last  happy months: ' ~ @happy[*-5 .. *];
say 'Dreary years count: ',  @years - @happy».year.uniq;
