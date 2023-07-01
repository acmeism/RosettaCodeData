my $i = -1; print $i, "\n" while ($i = index $str1, $str2, $i + 1) != -1;  # using index
