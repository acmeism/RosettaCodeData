my @array = <a z c d y>;
@array .= sort;  # short for @array = @array.sort;

say @array».uc;  # uppercase all the strings: A C D Y Z
