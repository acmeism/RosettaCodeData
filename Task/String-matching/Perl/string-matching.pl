# Using regexes:

$str1 =~ /^\Q$str2\E/  # true if $str1 starts with $str2
$str1 =~ /\Q$str2\E/   # true if $str1 contains $str2
$str1 =~ /\Q$str2\E$/  # true if $str1 ends with $str2

# Using index:

index($str1, $str2) == 0                               # true if $str1 starts with $str2
index($str1, $str2) != -1                              # true if $str1 contains $str2
rindex($str1, $str2) == length($str1) - length($str2)  # true if $str1 ends with $str2

# Using substr:

substr($str1, 0, length($str2)) eq $str2  # true if $str1 starts with $str2
substr($str1, - length($str2)) eq $str2   # true if $str1 ends with $str2

# Bonus task (printing all positions where $str2 appears in $str1):

print $-[0], "\n" while $str1 =~ /\Q$str2\E/g;  # using a regex
my $i = -1; print $i, "\n" while ($i = index $str1, $str2, $i + 1) != -1;  # using index
