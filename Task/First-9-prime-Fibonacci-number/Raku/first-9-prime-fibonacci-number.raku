put ++$ .fmt("%2d: ") ~ $_ for (0, 1, * + * … *).grep( &is-prime )[^20];
