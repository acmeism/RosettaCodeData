substr($str1, 0, length($str2)) eq $str2  # true if $str1 starts with $str2
substr($str1, - length($str2)) eq $str2   # true if $str1 ends with $str2
