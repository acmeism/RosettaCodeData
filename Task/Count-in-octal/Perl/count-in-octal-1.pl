use POSIX;
printf "%o\n", $_ for (0 .. POSIX::UINT_MAX);
