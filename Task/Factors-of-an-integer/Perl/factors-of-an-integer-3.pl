use ntheory qw/divisors/;
print join " ", divisors(12345678), "\n";
# Alternately something like:  fordivisors { say } 12345678;
