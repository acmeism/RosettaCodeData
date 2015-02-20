$str1 =~ /^\Q$str2\E/  # true if $str1 starts with $str2
$str1 =~ /\Q$str2\E/   # true if $str1 contains $str2
$str1 =~ /\Q$str2\E$/  # true if $str1 ends with $str2
