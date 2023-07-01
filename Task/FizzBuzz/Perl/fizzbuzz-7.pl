@FB1 = (1..100);
@FB2 = map{!($_%3 or $_%5)?'FizzBuzz': $_}@FB1;
@FB3 = map{(/\d/ and !($_%3))?'Fizz': $_}@FB2;
@FB4 = map{(/\d/ and !($_%5))?'Buzz': $_}@FB3;
@FB5 = map{$_."\n"}@FB4;
print @FB5;
