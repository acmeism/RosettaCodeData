sub factors (Int $n) { squish sort ($_, $n div $_ if $n %% $_ for 1 .. sqrt $n) }
